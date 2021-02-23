import tink.web.Response;
import haxe.Json;
import js.node.Require;
import tink.http.containers.*;
import tink.web.routing.*;
import tink.http.Response;
import js.Node;
import tink.http.Header.HeaderField;
import tjson.TJSON;

class Server {
	static function main() {
		var container = new NodeContainer(8080);
		var router = new Router<Root>(new Root());
		container.run(function(req) {
			return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
		});
		trace('Server started');
	}
}

class Root {
	public function new() {
		this.m_db = new HaxeLow('dbt.json');

		this.m_allCurrentTasks = this.m_db.col(Task);

		// var t = new Task('This mf task',HaxeLow.uuid());

		// trace(t.name);

		// m_allCurrentTasks.push(t);
		// m_allCurrentTasks.push(t2);
		// m_allCurrentTasks.push(t3);

		// trace(m_allCurrentTasks[0].name);
		// trace(m_allCurrentTasks[1].name);
		// trace(m_allCurrentTasks[2].name);

		this.m_db.save();
		trace(this.m_db.file);
	}

	public var m_db:HaxeLow;
	public var m_allCurrentTasks:Array<Task>;

	@:get('/tasks/get')
	public function GetAllTasks() {
		// trace("All tasks were required");
		//var body = TJSON.encode(this.m_allCurrentTasks);
		var body = Json.stringify(this.m_allCurrentTasks);
		
		var head = new ResponseHeader(200, 'Found', '');
		var res = new Response(head, body);
		trace(res.header);
		trace(res.body);

		return res;
	}

	@:options('/tasks/get')
	public function OptionsAllTasks() {

		var headerFields:Array<HeaderField> = new Array<HeaderField>();
		headerFields.push(new HeaderField('Access-Control-Allow-Origin', '*'));
		headerFields.push(new HeaderField('Access-Control-Allow-Methods', 'GET, POST, PATCH, PUT, DELETE, OPTIONS'));
		headerFields.push(new HeaderField('Access-Control-Allow-Headers', 'Content-Type'));
		headerFields.push(new HeaderField('Access-Control-Max-Age', '3600'));

		var head = new ResponseHeader(200, 'Found', headerFields);

		var res = new Response(head, "");
		return res;
	}
}
