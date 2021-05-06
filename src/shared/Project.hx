package;

class Project {
	public function new(name:String ,id: String) {
		this.name = name;
        this.id = id;
        this.timeOfCreation = Date.now().toString();
        this.totalSumSeconds = 0;
        this.associatedTasks = [];
	}

	public var name:String;
	public var id:String;//= HaxeLow.uuid();
	public var totalSumSeconds:Int;
	public var timeOfCreation:String;
    public var associatedTasks:Array<Task>;

    public function addTask(t:Task) {
            if(!associatedTasks.contains(t))
                {
                    associatedTasks.push(t);
                }
        }
}