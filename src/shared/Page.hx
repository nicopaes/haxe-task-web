package;

import tink.core.Future;
import tink.CoreApi.Promise;
import tink.http.Request.OutgoingRequestHeader;
import tink.http.Request.OutgoingRequest;
import tink.http.Fetch;
import js.html.ClientType;
import tink.http.Header.HeaderField;
import haxe.Json;
import tink.http.Client.*;
import tink.http.Protocol.*;

class Page {
	public var m_receivedTasks:Array<Task>;

	public var number:Int;

	public function new() {
		GetTasks();
	}

	public function LoadTasks(t:Array<Task>) {
		m_receivedTasks = t;
	}

	public function GetTasks() {
		// var c: OutgoingRequest = new OutgoingRequest(new OutgoingRequestHeader('GET','http://localhost:8080/tasks/get','HTTP_1'));
		fetch('http://localhost:8080/tasks/get', {
			method: GET,
			headers: [new HeaderField(CONTENT_TYPE, 'application/json')]
		}).all().handle(function(o) switch o {
			case Success(res):
				{
					trace(res.body.toString()); // Should trace the Task object
					trace("Get task sucess ${res.code}");
					var allT : Array<Task> = Json.parse(res.body.toString());
				}
			case Failure(e):
				trace(e);
				trace(e.data);
		});
	}
}
