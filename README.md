# JwplayerController

Little interface for making interactive videos with JW Player. The source code is made of Javascript for communications with JW Player and Dart for handling interactivity. The interactions are visible between videos, not during the videos. The aim of this code is to jump from one video to another, making kind of **videos where you are the hero**.

## Using this code for your interactive videos

With a minimal work, you can use this code for making other interactive videos project. 

**BEWARE** This repository don't contains JW Player 6 files. Get them at [http://www.jwplayer.com](http://www.jwplayer.com).

- **[build/web/](build/web/)** *This folder contains a sample project which can be run on a web server.*

- **[build/web/medias/](build/web/medias/)** *This folder contains videos and images shown between videos.*

- **[build/web/scenarios/](build/web/scenarios/)** *This folder contains interactive scenarios in JSON format.*

- **[build/web/jwplayer/](build/web/jwplayer/)** *This folder must contain JW Player 6 files. Get the files at JW Player website.*

If you want to make your own interactive videos project, with a minimal coding work, do the following:

1. Copy in your computer all files in [build/web/](build/web/) folder.
2. Delete files in [build/web/medias/](build/web/medias/) folder.
3. Copy your own videos and images in [build/web/medias/](build/web/medias/) folder.
4. Copy JW Player 6 files in [build/web/jwplayer/](build/web/jwplayer/).
5. Edit [build/web/index.html](build/web/index.html) to put your own JW Player key.
6. Copy and rename [build/web/scenarios/scenario01.json](build/web/scenarios/scenario01.json) in scenario02.json.
7. Edit your scenario02.json file.
8. Upload all your web/ folder to a wen server.
9. Run the file index.html?scenario=scenarios%2Fscenario02.json

Doing this, you just have two files to edit, the index.html for your JW Player key and the JSON file containing the scenario.

### Editing JSON file with interactive scenario

This file is built as a list of interactive nodes. A node consist of one video with a starting image and an ending image, plus 1 or 3 choices to lead to the next step of the scenario, that is the next interactive node. The first node is necessarily node000 :

```
"node000": {
    "imageIn": "firstVideoStart.jpg",
    "movie": "firstVideo.mp4",
    "imageOut": "firstVideoEnd.jpg",
    "nextText": {
      "text": "Where to go from now?",
      "top": "10%",
      "left": "10%"
    },
    "choice0": {
      "targetNode": "node001",
      "btnLabel": "This way?",
      "position": "absolute",
      "top": "60%",
      "left": "25%",
      "autostart": "true"
    },
    "choice1": {
      "targetNode": "node002",
      "btnLabel": "Or this way?",
      "position": "absolute",
      "top": "60%",
      "left": "45%",
      "autostart": "true"
    },
    "choice2": {
      "targetNode": "node003",
      "btnLabel": "May be this way?",
      "position": "absolute",
      "top": "60%",
      "left": "70%",
      "autostart": "true"
    }
  },
```

A node must contain data for imageIn, movie, imageOut, and data for at leat one choice = choice0. A choice must contain data for targetNode, btnLabel, position, top, left. The choice is displayed as a button above the ending image of the video. Its position is absolute in percentage of the player window (better for responsive design). the name of targetNode says which interactive node of the scenario to play after clicking the button.

### Simple HTTP streaming sample with OGG format

In this sample project, all the videos are playing locally from the web server. OGG video format is used for HTML5 compatibility in Chromium web browser. More complex streaming is possible by editing the source code file [web/jwplayerInterface.js](web/jwplayerInterface.js).


## Software License
This software is provided 'as-is', without any warranty. This software is distributed with [GNU GENERAL PUBLIC LICENSE Version 3](http://www.gnu.org/licenses/gpl.html). You can use, modify, copy, and distribute this edition as long as it’s for non-commercial use, you provide attribution, and share under a similar license.