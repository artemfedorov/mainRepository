package
{
	/*Task:
	Create a sample MVC(S) Robotlegs project using Robotlegs version 1.5.2. The project must implement the following concepts. 
		Please make sure the concepts are implemented in a practical and meaningful way.
		-Context
		-Model
		-View
		-Mediator
		-Controller (Command)
		-Service
		-Factory
		-Interface
		-Signals
		-Unit tests
	-Tweens (using Greensock)
		
	You are free to choose the functionality of the application if you think another application would showcase the above 
	concepts better, but an example of what we expect would be an application that loads images and presents them 
	in a collage-like fashion (calculate the optimal layout based on each image’s aspect ratio to obtain the minimal unused 
	screen space). After an image is clicked, it fades-out and is removed from the collage and another image is loaded, 
	fades-in, and the layout is updated. The removed images must get garbage-collected.
	We will be looking at your ability to understand the concepts and utilize them in a practical way. Code readability 
	(variable naming, code formatting), simplicity and modularity are values we will be looking for. Also animation skills 
	and tying animations into the otherwise synchronous state machine.
	Please host this project on GitHub to showcase your knowledge of Git.
	Extra task. Create a Maven configuration pom.xml for the project. It should include a test runner and working build config.*/

	import flash.display.Sprite;
	import flash.events.Event;
	import own.fedorov.engine.FGalleryContext;
	
	/**
	 * ...
	 * @author Artem Fedorov aka Wizard
	 */
	
	[SWF(width="1000", height="1000", frameRate="31", backgroundColor="0xC0C0C0")]
	
	public class FashionGallery extends Sprite
	{
		public function FashionGallery()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private var _context:FGalleryContext;
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_context = new FGalleryContext(this);
		}
	}
}