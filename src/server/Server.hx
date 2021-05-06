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

		//this.m_allCurrentTasks = this.m_db.col(Task);
		this.m_allProjects = this.m_db.col(Project);

		var p = new Project("Reigns",HaxeLow.uuid());

		var t = new Task('This mf task',HaxeLow.uuid());

		trace(p.name);
		trace(t.name);

		p.addTask(t);

		trace(p.associatedTasks.length);
		trace(p.timeOfCreation);

		m_allProjects.push(p);
		trace(m_allProjects[0].name);
		trace(m_allProjects[0].associatedTasks.length);

		// m_allCurrentTasks.push(t);
		// m_allCurrentTasks.push(t2);
		// m_allCurrentTasks.push(t3);

		
		// trace(m_allCurrentTasks[1].name);
		// trace(m_allCurrentTasks[2].name);

		this.m_db.save();
	}

	public var m_db:HaxeLow;
	public var m_allCurrentTasks:Array<Task>;
	public var m_allProjects:Array<Project>;

	// @:get('/tasks/get')
	// public function GetAllTasks() {
	// 	// trace("All tasks were required");
	// 	//var body = TJSON.encode(this.m_allCurrentTasks);
	// 	var body = Json.stringify(this.m_allCurrentTasks);
		
	// 	var head = new ResponseHeader(200, 'Found', '');
	// 	var res = new Response(head, body);
	// 	trace(res.header);
	// 	trace(res.body);

	// 	return res;
	// }

	// @:options('/tasks/get')
	// public function OptionsAllTasks() {

	// 	var headerFields:Array<HeaderField> = new Array<HeaderField>();
	// 	headerFields.push(new HeaderField('Access-Control-Allow-Origin', '*'));
	// 	headerFields.push(new HeaderField('Access-Control-Allow-Methods', 'GET, POST, PATCH, PUT, DELETE, OPTIONS'));
	// 	headerFields.push(new HeaderField('Access-Control-Allow-Headers', 'Content-Type'));
	// 	headerFields.push(new HeaderField('Access-Control-Max-Age', '3600'));

	// 	var head = new ResponseHeader(200, 'Found', headerFields);

	// 	var res = new Response(head, "");
	// 	return res;
	// }

	@:get('/projects/get')
	public function GetAllProjects() {
		trace("All projects were required");
		//var body = TJSON.encode(this.m_allCurrentTasks);
		var body = Json.stringify(this.m_allProjects);
		
		var head = new ResponseHeader(200, 'Found', '');
		var res = new Response(head, body);
		trace(res.header);
		trace(res.body);

		return res;
	}

	@:options('/projects/get')
	public function OptionsAllProjects() {

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
