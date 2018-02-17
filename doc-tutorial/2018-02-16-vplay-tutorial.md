---
layout: post
title: "V-Play Tutorial"
date: 2018-02-16 19:03:35
tags: [dev, v-play, qt]
#excerpt: 'Short text with markdown support'
categories: qt
#image: 'BASEURL/assets/blog/img/.png'
#photos: 'BASEURL/assets/blog/img/.png'
#description:
#permalink:
---

**Notice:: WIP :: This document is work in progress.**  
Resources: [Qt-5 docs](https://doc.qt.io/qt-5/index.html) , [V-Play docs](https://v-play.net/doc/), [OpenClipArt](https://openclipart.org/)


### Setup on Arch Linux
It's very easy to get started, download the package from <https://v-play.net/download/>, unpack and run the `*.run` executable. The `qt5-base` package is already installed on my system so the needed system libraries are installed too <small>(toolchain packaged on arch repos and v-plays toolchain are both quite recent, therefore dependencies of both are fine)</small>. I registered for the free Personal Pricing plan and logged into V-Plays Qt Creator after installation.

![Startup project]({{ site.baseurl }}/assets/blog/img/vplay-tutorial/vplay-001.png)

For disambiguation and convinient access to useful tools I created an application launcher:  
<small>Note the Exec line, the library path may need to be adjusted due archs different library packaging. <a href="https://bugreports.qt.io/browse/QTCREATORBUG-18137">(Source)</a></small>
```
[Desktop Entry]
Version=1.0
StartupNotify=false
Type=Application
NoDisplay=false
Terminal=false

Name=V-Play Qt Creator
Icon=%%VPLAY%%/VPlayLive/assets/vplay-logo.png
Exec=bash -c 'LD_LIBRARY_PATH=/usr/lib/openssl-1.0/ %%VPLAY%%/Tools/QtCreator/bin/qtcreator.sh %F'
Keywords=qt;c++;cpp;qml;vplay;v-play;work;qt creator;qtcreator;
Categories=Development;IDE;Qt;
Path=/home/gregor/aaDev/
TryExec=%%VPLAY%%/Tools/QtCreator/bin/qtcreator.sh
Actions=maint;vpdocs;qtdocs;oca;
StartupWMClass=qtcreator

[Desktop Action maint]
Name=MaintenanceTool
Exec=%%VPLAY%%/MaintenanceTool
[Desktop Action vpdocs]
Name=-> V-Play Docs
Exec=xdg-open "https://v-play.net/doc/"
[Desktop Action qtdocs]
Name=-> Qt Docs
Exec=xdg-open "https://doc.qt.io/qt-5/index.html"
[Desktop Action oca]
Name=-> OpenClipArt
Exec=xdg-open "https://openclipart.org/"
``` 

I will too try my first V-Play application on an Android phone. For deployment, both Android [SDK](https://developer.android.com/studio/index.html) and [NDK](https://developer.android.com/ndk/index.html) are needed. They can be set in Qt Creator at `Menu-> Tools-> Devices-> Android`. Qt toolchain components need to be installed too, the needed Android parts can be downloaded using the `MaintenanceTool` executable, which resides in V-Plays root folder.


