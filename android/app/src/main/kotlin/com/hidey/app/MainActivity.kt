package com.hidey.app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.Manifest
import android.content.ContentValues
import android.content.Context
import android.content.pm.PackageManager
import android.content.res.AssetManager
import android.graphics.*
import android.hardware.camera2.*
import android.hardware.camera2.params.OutputConfiguration
import android.hardware.camera2.params.SessionConfiguration
import android.media.Image
import android.media.ImageReader
import android.net.Uri
import android.os.*
import android.provider.MediaStore
import android.util.Log
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button
import android.widget.LinearLayout
import android.widget.Toast
import android.widget.VideoView
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.hidey.app.ImageUtil.Companion.bitmapToJpeg
import com.hidey.app.ImageUtil.Companion.bytesToBitmap
import com.hidey.app.ImageUtil.Companion.imageToNV21
import com.hidey.app.ImageUtil.Companion.matToByteBuffer
import com.hidey.app.ImageUtil.Companion.nv21ToBitmap
import com.hidey.app.ImageUtil.Companion.yuv420ToBitmap
import org.opencv.android.OpenCVLoader
import org.opencv.android.Utils
import org.opencv.core.*
import org.opencv.imgproc.Imgproc
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.InterpreterApi
import java.io.FileInputStream
import java.io.IOException
import java.nio.ByteBuffer
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {

    private lateinit var tflite: InterpreterApi
    private val handler = Handler()
    private lateinit var cameraManager: CameraManager
    private lateinit var frontCameraId: String

    private val capturedMats: MutableList<Mat> = mutableListOf()

    private var captureInterval = 15000 // 15 seconds, can be updated
    private val maxCaptures = 10
    private var continueCapturing = true

    private val MODEL_NAME = "hidey_camguard.tflite"
    private val TAG = "MainActivity"

    private var isPlaying = false

    private val CHANNEL = "hidey.privacy.com"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "start_video") {
                continueCapturing = true
                scheduleImageCapturingAndAnalysis(calculateCaptureInterval())
                result.success("true")
            } else if (call.method == "stop_video") {
                continueCapturing = false
                result.success("Android true also")
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.P)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        initializeOpenCV()
        initializeModel()
        initializeFrontCamera()
    }

    private fun initializeOpenCV() {
        if (!OpenCVLoader.initDebug()) {
            Toast.makeText(this, "OpenCV initialization failed", Toast.LENGTH_SHORT).show()
        } else {
            Toast.makeText(this, "OpenCV initialization succeeded", Toast.LENGTH_SHORT).show()
        }
    }

    private fun initializeModel() {
        // Load the model from assets
        val assetManager: AssetManager = assets
        val fileDescriptor = assetManager.openFd(MODEL_NAME)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength

        // Allocate a ByteBuffer for the model file
        val modelByteBuffer = ByteBuffer.allocateDirect(declaredLength.toInt())
        fileChannel.position(startOffset)
        fileChannel.read(modelByteBuffer)
        modelByteBuffer.rewind()

        // Initialize TensorFlow Lite interpreter
        val options = Interpreter.Options()
        tflite = Interpreter(modelByteBuffer, options)
    }

    private fun initializeFrontCamera() {
        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager

        // Find the front-facing camera
        for (cameraId in cameraManager.cameraIdList) {
            val characteristics = cameraManager.getCameraCharacteristics(cameraId)
            val cameraOrientation = characteristics.get(CameraCharacteristics.LENS_FACING)
            if (cameraOrientation == CameraCharacteristics.LENS_FACING_FRONT) {
                frontCameraId = cameraId
                break
            }
        }
    }

    private fun scheduleImageCapturingAndAnalysis(captureInterval: Long) {
        handler.postDelayed(object : Runnable {
            @RequiresApi(Build.VERSION_CODES.P)
            override fun run() {
                if (continueCapturing) {
                    captureAndAnalyze()
                    handler.postDelayed(this, captureInterval)
                }
            }
        }, 1000)
    }

    private fun calculateCaptureInterval(): Long {
        //TODO: This will be determined by the duration of the video, we will work it out later
        //return hardcoded value for now
        return captureInterval.toLong()
    }

    private fun quitVideoPlayer() {

    }

    @RequiresApi(Build.VERSION_CODES.P)
    private fun captureAndAnalyze() {
        Log.i(TAG, "Starting capture And Analysis... ")

        val imageReader = ImageReader.newInstance(640, 480, ImageFormat.YUV_420_888, maxCaptures)

        val cameraStateCallback = object : CameraDevice.StateCallback() {
            override fun onOpened(camera: CameraDevice) {
                val captureRequestBuilder = camera.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
                captureRequestBuilder.addTarget(imageReader.surface)
                val captureRequest = captureRequestBuilder.build()

                val outputs: MutableList<OutputConfiguration> = ArrayList()
                outputs.add(OutputConfiguration(imageReader.surface))
                val sessionConfig = SessionConfiguration(SessionConfiguration.SESSION_REGULAR, outputs, AsyncTask.THREAD_POOL_EXECUTOR, object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(session: CameraCaptureSession) {
                        session.setRepeatingRequest(captureRequest, null, handler)

                        imageReader.setOnImageAvailableListener({ reader ->
                            Log.i(TAG, "Captured image: %s".format(capturedMats.size))
                            val image = reader.acquireLatestImage()
                            if (image != null) {
                                val buffer = image.planes[0].buffer
                                val bytes = ByteArray(buffer.remaining())
                                buffer.get(bytes)

                                // Save the image to a folder
                                saveImageToDevice(image)

                                val mat = Mat()
                                Utils.bitmapToMat(yuv420ToBitmap(image), mat)
                                Imgproc.cvtColor(mat, mat, Imgproc.COLOR_RGBA2RGB)

                                // Resize the Mat to the required dimensions for the model
                                val resizedMat = Mat()
                                Imgproc.resize(mat, resizedMat, Size(128.0, 128.0))
                                capturedMats.add(resizedMat)
                                //mat.release() // Free up the memory
                                image.close()
                            }

                            if (capturedMats.size >= maxCaptures) {
                                session.close() //close capture session
                                Log.i(TAG, "Max Capture reached: %s".format(capturedMats.size))

                                if (inspectImageForCamera(capturedMats)) {
                                    Log.i(TAG, "CAMERA DETECTED")
                                    handler.post {
                                        Toast.makeText(applicationContext, "Camera detected!", Toast.LENGTH_SHORT).show()
                                        // stop video playback here
                                        quitVideoPlayer()
                                        continueCapturing = false
                                    }
                                } else {
                                    Log.i(TAG, " --------------->>>>>>>>>>>> CAMERA NOT DETECTED")
                                }
                                capturedMats.clear()
                            }
                        }, handler)
                    }

                    override fun onConfigureFailed(session: CameraCaptureSession) {}
                })

                camera.createCaptureSession(sessionConfig)

            }

            override fun onDisconnected(camera: CameraDevice) {}
            override fun onError(camera: CameraDevice, error: Int) {}
        }

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Request camera permission here
            return
        }
        cameraManager.openCamera(frontCameraId, cameraStateCallback, handler)
    }

    private fun saveImageToDevice(image: Image) {
        //val jpegBytes = toJpegImage(image, 100)
        val jpegBytes = bitmapToJpeg(yuv420ToBitmap(image))
        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, "IMG_$timestamp.jpg")
            put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg")
            put(MediaStore.MediaColumns.RELATIVE_PATH, "DCIM/MyCapturedImages")
        }

        val uri: Uri? = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

        uri?.let {
            val outputStream = contentResolver.openOutputStream(it)

            outputStream?.use { os ->
                // Write your image bytes here
                os.write(jpegBytes)
                os.flush()
            }
        } ?: run {
            Log.e(TAG, "Failed to create new MediaStore record.")
        }
    }


    private fun inspectImageForCamera(capturedMats: MutableList<Mat>): Boolean {

        // Loop through each captured image for analysis
        for (originalMat in capturedMats) {
            // Assume isCameraDetected is determined from contours, edges, etc.
            //val isCameraDetected = analyzeMats(originalMat):
            val isCameraDetected = true

            if (isCameraDetected) {
                // Prepare the preprocessed image for ML model
                val inputBuffer: ByteBuffer = matToByteBuffer(originalMat)// Convert your Mat to ByteBuffer

                // Perform ML inference
                val output = Array(1) { FloatArray(2) }  // Assume binary classification
                tflite.run(inputBuffer, output)

                // Post-process ML model output
                Log.i(TAG, output.contentDeepToString())
                Log.i(TAG, "Model output is: %s".format(output[0][1]))
                if (output[0][1] > 0.6) {  // Just an example condition
                    // Confirmed, it is a camera
                    return true
                }
            }

        }
        return false
    }

    private fun analyzeMats(mat: Mat): Boolean {
        // Image Preprocessing and Basic Analysis
        val blurredMat = Mat()
        Imgproc.GaussianBlur(mat, blurredMat, Size(5.0, 5.0), 0.0)

        val edgesMat = Mat()
        Imgproc.Canny(blurredMat, edgesMat, 100.0, 200.0)

        val contours: MutableList<MatOfPoint> = ArrayList()
        val hierarchy = Mat()
        Imgproc.findContours(edgesMat, contours, hierarchy, Imgproc.RETR_EXTERNAL, Imgproc.CHAIN_APPROX_SIMPLE)

        return analyzeContours(contours)

    }

    private fun analyzeContours(contours: MutableList<MatOfPoint>): Boolean {
        // Initialize variables to store criteria
        var contourCount = 0
        var hasCircularShape = false
        var hasRectangularShape = false

        // Loop through each contour and analyze
        for (contour in contours) {
            val area = Imgproc.contourArea(contour)
            if (area > 100) {  // Arbitrary area threshold
                contourCount++

                val peri = Imgproc.arcLength(MatOfPoint2f(*contour.toArray()), true)
                val approx = MatOfPoint2f()
                Imgproc.approxPolyDP(MatOfPoint2f(*contour.toArray()), approx, 0.02 * peri, true)

                val total = approx.total().toInt()
                if (total == 4) {
                    hasRectangularShape = true
                } else if (total > 6) {  // The higher the total, the more circular the shape
                    hasCircularShape = true
                }
            }
        }
        //Implement your specific criteria here
        return contourCount > 2 && (hasCircularShape || hasRectangularShape)
    }

    // Function to load test images and run the model on them
    private fun testModelOnImages() {
        val assetManager = assets
        try {
            val imagesList = assetManager.list("camera_present") // "test_images" is the folder where test images are stored
            if (imagesList != null) {
                for (image in imagesList) {
                    val inputStream = assetManager.open("camera_present/$image")
                    val bitmap = BitmapFactory.decodeStream(inputStream)
                    val mat = Mat()
                    Utils.bitmapToMat(bitmap, mat)
                    Imgproc.cvtColor(mat, mat, Imgproc.COLOR_RGBA2RGB)

                    // Resize the Mat to the required dimensions for the model
                    val resizedMat = Mat()
                    Imgproc.resize(mat, resizedMat, Size(128.0, 128.0))

                    val inputBuffer: ByteBuffer = matToByteBuffer(resizedMat) // Assuming you have a function to convert Mat to ByteBuffer

                    // Run the model
                    val output = Array(1) { FloatArray(2) }
                    tflite.run(inputBuffer, output)

                    Log.i(TAG, "For image: $image, model output is: ${output[0].contentToString()}")

                    inputStream.close()
                }
            }
        } catch (e: IOException) {
            Log.e(TAG, "Error in reading assets", e)
        }
    }

}