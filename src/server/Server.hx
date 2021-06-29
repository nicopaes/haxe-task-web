import sys.ssl.Key;
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
		// var port = Node.process.env.get("PORT");
		// trace(port);
		// $NodeContainer_ServerKindBase.Port(process.env.PORT ||
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

		// this.m_allCurrentTasks = this.m_db.col(Task);
		this.m_allProjects = this.m_db.col(Project);

		// var p = new Project("Reigns",HaxeLow.uuid());

		// var t = new Task('This mf task',HaxeLow.uuid());

		// trace(p.name);
		// trace(t.name);

		// //p.addTask(t);

		// trace(p.associatedTasks.length);
		// trace(p.timeOfCreation);

		// m_allProjects.push(p);
		for (index => p in m_allProjects) {
			trace('$index => ${p.name} => Tasks: ${p.associatedTasks.length}');
		}

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

	/*

		// curl -i -X POST http://localhost:8080/projects/3fd98ce3-3ce4-4136-84fc-de4caf27179d/tasks/3fd98ce4-beb5-4085-b273-d101fee81d96/start
		//
	 */
	// POST TASK START

	@:post('/projects/$projectid/tasks/$taskid/start')
	public function StartTask(projectid:String, taskid:String) {
		trace('\nPOST:\nPROJECT: ${projectid}\nTASKSTART: $taskid');

		this.m_allProjects = this.m_db.col(Project);
		var _project:Project = null;

		// trace(taskname);
		for (index => p in this.m_allProjects) {
			if (p.id == projectid) {
				trace(index);
				trace(projectid);
				_project = this.m_allProjects[index];
			}
		}

		if (_project != null) {
			trace(_project.name);
			if (_project.StartTask(taskid)) {
				trace("Sucess start task");
				this.m_db.save();
			} else {
				trace("FAIL start task");
			}
		}

		var head:ResponseHeader;
		var body:String;

		if (_project != null) {
			head = new ResponseHeader(200, 'Found', '');
			body = "Sucess";
		} else {
			head = new ResponseHeader(404, 'Not found', '');
			body = "Not found";
		}

		var res = new Response(head, body);

		return res;
	}

	// POST TASK STOP

	/*

		// curl -i -X POST http://localhost:8080/projects/3fd98ce3-3ce4-4136-84fc-de4caf27179d/tasks/3fd98ce4-beb5-4085-b273-d101fee81d96/stop

	 */
	@:post('/projects/$projectid/tasks/$taskid/stop')
	public function StopTask(projectid:String, taskid:String) {
		trace('\nPOST:\nPROJECT: ${projectid}\nTASKSTOP: $taskid');

		this.m_allProjects = this.m_db.col(Project);
		var _project:Project = null;

		// trace(taskname);
		for (index => p in this.m_allProjects) {
			if (p.id == projectid) {
				trace(index);
				trace(projectid);
				_project = this.m_allProjects[index];
			}
		}

		if (_project != null) {
			trace(_project.name);
			if (_project.StopTask(taskid)) {
				trace("Sucess stop task");
				this.m_db.save();
			} else {
				trace("FAIL stop task");
			}
		}

		var head:ResponseHeader;
		var body:String;

		if (_project != null) {
			head = new ResponseHeader(200, 'Found', '');
			body = "Sucess";
		} else {
			head = new ResponseHeader(404, 'Not found', '');
			body = "Not found";
		}

		var res = new Response(head, body);

		return res;
	}

	// POST TASK CREATE

	/*

		// curl -i -X POST http://localhost:8080/projects/3fd98ce3-3ce4-4136-84fc-de4caf27179d/tasks/NEWTASK
		// curl -i -X POST http://localhost:8080/projects/553ea1af-90aa-4e6f-8663-9085bca79cbd/tasks/Nicolas%20Task%20

	 */
	@:post('/projects/$projectid/tasks/$taskname')
	public function CreateTask(projectid:String, taskname:String) {
		trace('\nPOST:\nPROJECT: ${projectid}\nTASKSCREATE: $taskname');

		this.m_allProjects = this.m_db.col(Project);
		var _project:Project = null;

		var sucess:Bool = false;
		var newTask:Task = null;

		// trace(taskname);
		for (index => p in this.m_allProjects) {
			if (p.id == projectid) {
				trace(index);
				trace(projectid);
				_project = this.m_allProjects[index];
			}
		}

		if (_project != null) {
			trace(_project.name);
			newTask = new Task(taskname, HaxeLow.uuid(), _project.id);
			if (_project.addTask(newTask)) {
				sucess = true;
				this.m_db.save();
			}
		}

		var head:ResponseHeader;
		var body:String;

		if (sucess) {
			head = new ResponseHeader(200, 'Found', '');
			body = Json.stringify(newTask);
			trace(body);
		} else {
			head = new ResponseHeader(404, 'Not created', '');
			body = "Not created";
		}

		var res = new Response(head, body);

		return res;
	}

	// POST PROJECT CREATE

	/*

		// curl -i -X POST http://localhost:8080/projects/NEWPROJECT

	 */
	@:post('/projects/$projectname')
	public function CreateProject(projectname:String) {
		trace('\nPOST:\nPROJECT CREATE: $projectname');

		this.m_allProjects = this.m_db.col(Project);
		var sucess:Bool = false;
		var countBefore:Int = this.m_allProjects.length;

		this.m_allProjects.push(new Project(projectname, HaxeLow.uuid()));
		var countAfter:Int = this.m_allProjects.length;

		sucess = countBefore < countAfter;
		if (sucess) {
			this.m_db.save();
		}

		var head:ResponseHeader;
		var body:String;

		if (sucess) {
			head = new ResponseHeader(200, 'Created', '');
			body = "Sucess";
		} else {
			head = new ResponseHeader(404, 'Not created', '');
			body = "Not created";
		}

		var res = new Response(head, body);

		return res;
	}

	@:get('/projects/get')
	public function GetAllProjects() {
		trace("All projects were required");
		// var body = TJSON.encode(m_allProjects,'fancy');
		// var body = Json.stringify(m_db.backup());
		var body = m_db.backup();

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
