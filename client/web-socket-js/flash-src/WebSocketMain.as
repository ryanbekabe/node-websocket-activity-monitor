// Copyright: Hiroshi Ichikawa <http://gimite.net/en/>
// Lincense: New BSD Lincense
// Reference: http://dev.w3.org/html5/websockets/
// Reference: http://tools.ietf.org/html/draft-hixie-thewebsocketprotocol-31

package {

import flash.display.*;
import flash.events.*;
import flash.external.*;
import flash.net.*;
import flash.system.*;
import flash.utils.*;
import mx.core.*;
import mx.controls.*;
import mx.events.*;
import mx.utils.*;
import bridge.FABridge;

public class WebSocketMain extends Sprite {

  private var policyLoaded:Boolean = false;
  private var callerUrl:String;

  public function WebSocketMain() {
    var fab:FABridge = new FABridge();
    fab.rootObject = this;
    //log("Flash initialized");
  }
  
  public function setCallerUrl(url:String):void {
    callerUrl = url;
  }

  public function create(url:String, protocol:String):WebSocket {
    loadPolicyFile(null);
    return new WebSocket(this, url, protocol);
  }

  public function getOrigin():String {
    return (URLUtil.getProtocol(this.callerUrl) + "://" +
      URLUtil.getServerNameWithPort(this.callerUrl)).toLowerCase();
  }

  public function loadPolicyFile(url:String):void {
    if (policyLoaded && !url) return;
    if (!url) {
      url = "xmlsocket://" + URLUtil.getServerName(this.callerUrl) + ":843";
    }
    log("policy file: " + url);
    Security.loadPolicyFile(url);
    policyLoaded = true;
  }

  public function log(message:String):void {
    ExternalInterface.call("webSocketLog", "[WebSocket] " + message);
  }

  public function fatal(message:String):void {
    ExternalInterface.call("webSocketError", "[WebSocket] " + message);
    throw message;
  }

}

}
