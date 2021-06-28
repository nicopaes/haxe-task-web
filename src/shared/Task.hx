package;

class Task {
	public function new(name:String, id:String, projectid:String) {
		this.name = name;
		this.id = id;
		this.projectid = projectid;
		this.totalDuration = 0;
		this.setStarts = [];
		this.setStops = [];
		this.timeOfCreation = Date.now().toString();
	}

	public var name:String;
	public var id:String; // = HaxeLow.uuid();	
	public var projectid:String;
	public var timeOfCreation:String;
	//
	public var totalDuration:Int;
	public var setStarts:Array<String>;
	public var setStops:Array<String>;

	public function addStart(timeS:String) {
		setStarts.push(timeS);
	}

	public function addStop(timeS:String) {
		setStops.push(timeS);
	}
}
