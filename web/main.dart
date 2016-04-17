// Copyright (c) 2016, Philippe Brouard. All rights reserved. Use of this source code
// is governed by a GNU V3 license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

Map jsonData;
String currentNode = "node000";

ParagraphElement nextText;
ButtonElement sampleButtonA;
ButtonElement sampleButtonB;
ButtonElement sampleButtonC;
DivElement interactions;

// subscriptions sont les actions affectées aux boutons.
var subscriptionA;
var subscriptionB;
var subscriptionC;


void main() {
  nextText = querySelector("#nextText") as ParagraphElement;
  sampleButtonA = querySelector("#sampleButtonA") as ButtonElement;
  sampleButtonB = querySelector("#sampleButtonB") as ButtonElement;
  sampleButtonC = querySelector("#sampleButtonC") as ButtonElement;
  interactions = querySelector("#interactions") as DivElement;

  // début du traitement, charger le scénario JSON
  makeRequest();

  // ecouter l'événement fin de vidéo
  window.on['videoComplete'].listen((e) {
    if (e.detail.toString() != "")
    {
      //print("ok detail");
    }

    interactions.classes.remove("hide");
    if (jsonData[currentNode]["nextText"] != null)
    {
      nextText.text = jsonData[currentNode]["nextText"]["text"];
      nextText.style.top = jsonData[currentNode]["nextText"]["top"];
      nextText.style.left = jsonData[currentNode]["nextText"]["left"];
    }

    if (subscriptionA != null) subscriptionA.cancel();
    if (subscriptionB != null) subscriptionB.cancel();
    if (subscriptionC != null) subscriptionC.cancel();

    sampleButtonA.style.display = "none";
    sampleButtonB.style.display = "none";
    sampleButtonC.style.display = "none";

    var nbchoices = jsonData[currentNode].keys.length - 3;
    var i = 0;
    for (i = 0; i < nbchoices; i++) {
      switch (i) {
        case 0 : buildInteractionChoice(currentNode, "choice0", sampleButtonA); break;
        case 1 : buildInteractionChoice(currentNode, "choice1", sampleButtonB); break;
        case 2 : buildInteractionChoice(currentNode, "choice2", sampleButtonC); break;
      }
    }
  });
}

void makeRequest()
{
  //var path = 'scenarios/scenario01.json';
  var path = "";
  Location currentLocation = window.location;
  var decoded = Uri.decodeFull(currentLocation.href);
  if (decoded.contains("scenario="))
  {
    //print(decoded.substring(decoded.indexOf("media=")+6));
    path = decoded.substring(decoded.indexOf("scenario=")+9);

    HttpRequest.getString(path)
        .then(processString)
        .catchError(handleError);

  }

}

void processString(String jsonString) {
  jsonData = JSON.decode(jsonString);

  var imageIn = jsonData["node000"]["imageIn"];
  var movie = jsonData["node000"]["movie"];
  var imageOut = jsonData["node000"]["imageOut"];

  /* cette syntaxe est sans doute dépréciée, en fait non, mais j'ai repéré un problème de sérialisation CustomEvent avec Dart 1.15
  window.dispatchEvent(new CustomEvent("setupAction", detail:{ "imageFileIn":imageIn,
                                                                "videoFile":movie,
                                                                "imageFileOut":imageOut
                                                              }
                                      )
  );
  */
  var detail = new Map();
  detail["imageFileIn"] = imageIn;
  detail["videoFile"] = movie;
  detail["imageFileOut"] = imageOut;
  // on va utiliser jsonencoder pour sérialiser intentionnellement les détails du customEvent, autrement ça ne passe pas, Dart 1.15
  var jse = new JsonEncoder();

  CustomEvent evt;

  evt = new CustomEvent("setupAction", detail:jse.convert(detail), cancelable:true, canBubble:true);

  window.dispatchEvent(evt);

}

void handleError(Error error)
{
  print('error request');
}


void buildInteractionChoice(String node, String choice, ButtonElement btn)
{
  //print("buildInteractionChoice : " + node + " " + choice + " " + btn.toString());
  // creation de l'action sur le bouton.
  var btnLabel = jsonData[node][choice]["btnLabel"];
  var topPos = jsonData[node][choice]["top"];
  var leftPos = jsonData[node][choice]["left"];

  var targetNode = jsonData[node][choice]["targetNode"];
  var imageIn = "";
  var movie = "";
  var imageOut = "";

  var autostart = jsonData[node][choice]["autostart"];

  //print("targetNode : " + targetNode);

  if ((targetNode != null) && (targetNode != "")) {
    if (jsonData[targetNode] != null)
    {
      imageIn = jsonData[targetNode]["imageIn"];
      movie = jsonData[targetNode]["movie"];
      imageOut = jsonData[targetNode]["imageOut"];

      setupComplexButton(btn, "complexAction", imageIn, movie, imageOut, topPos, leftPos, btnLabel, targetNode, autostart);
      btn.style.display = "block";
    }

  }
  else
  {
    btn.style.display = "none";
  }
}


void setupComplexButton(ButtonElement btn, String strEvent, String strValueA, String strValueB, String strValueC, String toppos, String leftpos, String btnLabel, String targetNode, String autostart)
{
  //print("setupComplexButton : " + strEvent + " " + strValueA + " " + strValueB + " " + strValueC);
  var detail = new Map();
  detail["imageFileIn"] = strValueA;
  detail["videoFile"] = strValueB;
  detail["imageFileOut"] = strValueC;
  detail["autostart"] = autostart;
  // on va utiliser jsonencoder pour sérialiser intentionnellement les détails du customEvent, autrement ça ne passe pas, Dart 1.15
  var jse = new JsonEncoder();

  CustomEvent evt;

  evt = new CustomEvent(strEvent, detail:jse.convert(detail), cancelable:true, canBubble:true);

  if (btn == sampleButtonA)
  {

    subscriptionA = btn.onClick.listen((e) { window.dispatchEvent(evt);
                                              currentNode = targetNode;
                                            });
  } else if (btn == sampleButtonB)
  {
    subscriptionB = btn.onClick.listen((e) { window.dispatchEvent(evt);
                                              currentNode = targetNode;
                                            });
  } else if (btn == sampleButtonC)
  {
    subscriptionC = btn.onClick.listen((e) { window.dispatchEvent(evt);
                                              currentNode = targetNode;
                                            });
  }

  btn.style.top = toppos;
  btn.style.left = leftpos;
  btn.text = btnLabel;
}
