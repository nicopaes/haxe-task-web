package;

class Task {
	public function new(name:String ,id: String) {
		this.name = name;
        this.id = id;
		this.totalDuration = 0;
		this.setStarts = [];
		this.setStops = [];
	}

	public var name:String;
	public var id:String;//= HaxeLow.uuid();
	public var totalDuration:Int;
	public var setStarts:Array<String>;
	public var setStops:Array<String>;
}