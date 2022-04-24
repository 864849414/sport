package com.sport583.sport

import android.app.Activity
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.provider.CalendarContract
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.webkit.*
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.appcompat.widget.Toolbar
import java.lang.Exception

class WebVideoActivity : Activity() {
    internal var wvBookPlay: WebView? = null
    var toolbar: Toolbar?=null
    var isFull=false
    var jsList:List<String>?=null;
    internal lateinit var flVideoContainer: FrameLayout
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_video)

        wvBookPlay = findViewById(R.id.web_view)
        toolbar = findViewById(R.id.toobar)

        findViewById<ImageView>(R.id.btn_back).setOnClickListener {
            if(isFull){
                wvBookPlay!!.goBack()
            }else{
                onBackPressed()
            }
            }

        flVideoContainer = findViewById(R.id.flVideoContainer)

        wvBookPlay!!.settings.javaScriptEnabled = true
        wvBookPlay!!.settings.useWideViewPort = true
        wvBookPlay!!.settings.loadWithOverviewMode = true
        wvBookPlay!!.settings.allowFileAccess = true
        wvBookPlay!!.settings.setSupportZoom(true)
        wvBookPlay!!.settings.javaScriptCanOpenWindowsAutomatically = true
        wvBookPlay!!.settings.domStorageEnabled=true;
        try {
            if (Build.VERSION.SDK_INT >= 16) {
                val clazz = wvBookPlay!!.settings.javaClass
                val method = clazz.getMethod("setAllowUniversalAccessFromFileURLs", Boolean::class.javaPrimitiveType)
                if (method != null) {
                    method.invoke(wvBookPlay!!.settings, true)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        wvBookPlay!!.settings.pluginState = WebSettings.PluginState.ON
        wvBookPlay!!.settings.domStorageEnabled = true// 必须保留，否则无法播放优酷视频，其他的OK
        wvBookPlay!!.webChromeClient = MyWebChromeClient()// 重写一下，有的时候可能会出现问题
        wvBookPlay!!.webViewClient = MyWeb()// 重写一下，有的时候可能会出现问题

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            wvBookPlay!!.settings.mixedContentMode = 0
        }

        val url = intent.getStringExtra("key_url")
        val jsString = intent.getStringExtra("key_js")
        jsList= jsString.split(",")

        val cookieManager = CookieManager.getInstance()
        val stringBuffer = StringBuffer()
        stringBuffer.append("android")

        cookieManager.setCookie(url, stringBuffer.toString())
        cookieManager.setAcceptCookie(true)

        wvBookPlay!!.loadUrl(url)
    }

    override fun onConfigurationChanged(config: Configuration) {
        super.onConfigurationChanged(config)
        when (config.orientation) {
            Configuration.ORIENTATION_LANDSCAPE -> {
                window.clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
                window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            }
            Configuration.ORIENTATION_PORTRAIT -> {
                window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                window.addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN)
            }
        }
    }

    private inner class MyWebChromeClient : WebChromeClient() {
        internal lateinit var mCallback: CustomViewCallback
        override fun onShowCustomView(view: View, callback: CustomViewCallback) {
            Log.i("ToVmp", "onShowCustomView")
            fullScreen()
            isFull=true
            toolbar!!.setBackgroundColor(Color.TRANSPARENT)
            wvBookPlay!!.visibility = View.GONE
            flVideoContainer.visibility = View.VISIBLE
            flVideoContainer.addView(view)
            mCallback = callback
            super.onShowCustomView(view, callback)
        }



        override fun onHideCustomView() {
            Log.i("ToVmp", "onHideCustomView")
            fullScreen()
            isFull=false;
            toolbar!!.setBackgroundColor(Color.parseColor("#FFE3494B"))
            wvBookPlay!!.visibility = View.VISIBLE
            flVideoContainer.visibility = View.GONE
            flVideoContainer.removeAllViews()
            super.onHideCustomView()

        }


    }

    internal inner class MyWeb : WebViewClient() {
        override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
            view.loadUrl(url)//在这里设置对应的操作
            return false
        }

        override fun onPageFinished(view: WebView, url: String) {
            super.onPageFinished(view, url)

            if(jsList!=null&&url!="about:blank"){
               for ( index in jsList!!){
                    println("loadUrl:"+index)
                }
            }
        }

        override fun onReceivedError(view: WebView, request: WebResourceRequest, error: WebResourceError) {
            super.onReceivedError(view, request, error)
        }
    }

    private fun fullScreen() {
        if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
            Log.i("ToVmp", "横屏")
        } else {
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
            Log.i("ToVmp", "竖屏")
        }
    }

    override fun onDestroy() {
        if (wvBookPlay != null) {
            wvBookPlay!!.destroy()
        }
        super.onDestroy()
    }
}