package ember.core
{
	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	
	final internal class Entities
	{
		private var _list:Vector.<Entity>;
		private var _nameMap:Dictionary;
		private var _count:uint;
		
		private var _entityComponentAdded:Signal;
		private var _entityComponentRemoved:Signal;
		private var _entityRemoved:Signal;
		
		public function Entities()
		{
			_list = new Vector.<Entity>();
			_nameMap = new Dictionary();
			_count = 0;
			
			_entityComponentAdded = new Signal(Entity, Class);
			_entityComponentRemoved = new Signal(Entity, Class);
			_entityRemoved = new Signal(Entity);
		}

		public function create(name:String = ""):Entity
		{
			var entity:Entity = new Entity(name, _entityComponentAdded, _entityComponentRemoved);
			_count = _list.push(entity);
			
			if (name != "")
			{
				var existing:Entity = _nameMap[name];
				if (existing != null)
					throw new Error("You cannot call two entities the same name");
				
				_nameMap[name] = entity;
				_nameMap[entity] = name;
			}
			
			return entity;
		}
		
		public function get(name:String):Entity
		{
			return _nameMap[name];
		}

		public function getAll():Vector.<Entity>
		{
			return _list.concat();
		}

		public function contains(entity:Entity):Boolean
		{
			return _list.indexOf(entity) != -1;
		}
		
		public function remove(entity:Entity):void
		{
			var i:int = _list.indexOf(entity);
			if (i == -1)
				return;

			var name:String = _nameMap[entity];
			if (name != null)
			{
				delete _nameMap[entity];
				delete _nameMap[name];
			}
			
			_list.splice(i, 1);
		}
		
		public function removeAll():void
		{
			_list.length = 0;
		}

		public function get list():Vector.<Entity>
		{
			return _list;
		}
		
		public function get entityComponentAdded():Signal
		{
			return _entityComponentAdded;
		}
		
		public function get entityComponentRemoved():Signal
		{
			return _entityComponentRemoved;
		}

		public function get entityRemoved():Signal
		{
			return _entityRemoved;
		}
	
	}
}
