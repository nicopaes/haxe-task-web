import haxe.ui.components.Label;
import haxe.ui.containers.TableView;
import js.html.Text;
import haxe.ui.HaxeUIApp;
import haxe.ui.events.MouseEvent;
import haxe.Json;
import tink.http.Fetch.FetchOptions;
import tink.web.proxy.Remote;
import tink.http.Client.*;
import haxe.ui.components.Button;
import haxe.ui.containers.VBox;
import haxe.ui.core.Screen;
import haxe.ui.Toolkit;
import tink.http.Header.HeaderField;
import tjson.TJSON;

class Client {
	static function main() {
		Toolkit.theme = "dark";
		Toolkit.init();
		var c:Client = new Client();
	}

	public function new() {
		trace("Client created");
		var app = new HaxeUIApp();
		app.ready(function() {
			var main = new VBox();

			// var button = new Button();
			// button.text = "TEST";
			// button.onClick = function(e) {
			// 	this.Test();
			// }
			// main.addComponent(button);

			// var button2 = new Button();
			// button2.text = "TEST2";
			// button2.onClick = function(e) {
			// 	Test2();
			// }
			// main.addComponent(button2);

			Screen.instance.addComponent(main);
		});
		fetch('http://localhost:8080/tasks/get', {
				method: GET,
				headers: [new HeaderField(CONTENT_TYPE, 'application/json')]
			}).all().handle(function(o) switch o {
				case Success(res):
					{
						var resString = res.body.toString();						
						trace (resString);
						trace("-----------------------------------------------");
						var TEST : Array<Task> = Json.parse(resString);	

						trace(TEST.length);
						trace(TEST.toString());
						trace("-----------------------------------------------");
						var allT:Array<Task> = Json.parse("[{\"_hxcls\":\"Task\",\"name\":\"This mf task\",\"id\":\"9c50a7fd-38c6-4dda-ada8-c2b46eff006f\"},{\"_hxcls\":\"Task\",\"name\":\"This mf task 2 \",\"id\":\"9c50a7fe-e2b4-4797-a873-a36d101f385c\"},{\"_hxcls\":\"Task\",\"name\":\"This mf task 2 \",\"id\":\"9c50a7fe-5d3b-4759-9d3b-22ff8e1a8a06\"}]");	
						
						trace(allT.toString());
						trace(allT.length);

						// for (t in allT) 
						// {
						// 	trace(t.id);
						// 	var l : Label = new Label();

						// 	l.htmlText = '<b>${t.name}</b>';							
						// 	Screen.instance.addComponent(l);
						// }
					}
				case Failure(e):
					trace(e);
					trace(e.data);
			});
	}

	public function Test() {
		trace("Motherfucking task");
		// var p = new Page();
	}

	public function Test2() {
		trace("This is another test");
	}
}
