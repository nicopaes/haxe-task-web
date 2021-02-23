package;

class Task {
	public function new(name:String ,id: String) {
		this.name = name;
        this.id = id;
	}

	public var name:String;
	public var id:String;//= HaxeLow.uuid();
}