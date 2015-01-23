package model 
{

	
	import com.greensock.easing.FastEase;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	
	import views.GameView;
	import views.InterfaceView;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameModel extends superClasses.BaseClass 
	{
		
		private var _currentGameType:String;
		private var _currentGameIndex:int;
		private var _games:Array;
		
		private var _constructGames:Array;
		private var _matchGames:Array;
		private var _bubblesGames:Array;
		private var _piecesGames:Array;
		private var _sortingGames:Array;

		private var _activeGames:Array;
		
		
		
		public function GameModel() 
		{
			super();
		}
		
		public function get activeGames():Array
		{
			return _activeGames;
		}

		public function set activeGames(value:Array):void
		{
			_activeGames = value;
		}

		override protected function onRegister():void 
		{
			_constructGames = [];
			_constructGames.push(Assets.construct1);
			_constructGames.push(Assets.construct2);
			_constructGames.push(Assets.construct3);

			_piecesGames = [];
			_piecesGames.push(Assets.pieces1);
			_piecesGames.push(Assets.pieces2);
			_piecesGames.push(Assets.pieces3);

			_bubblesGames = [];
			_bubblesGames.push(Assets.bubble);

			_sortingGames = [];
			_sortingGames.push(Assets.sorting1);
			_sortingGames.push(Assets.sorting2);

			_matchGames = [];
			_matchGames.push(Assets.match2game1);
			_matchGames.push(Assets.match2game2);
			_matchGames.push(Assets.match2game3);
			_matchGames.push(Assets.match2game4);
			_matchGames.push(Assets.match2game5);
			_matchGames.push(Assets.match2game6);
			_matchGames.push(Assets.match2game7);
			_matchGames.push(Assets.match2game8);
			_matchGames.push(Assets.match2game9);
			_matchGames.push(Assets.match2game10);
			_matchGames.push(Assets.match2game11);
			_matchGames.push(Assets.match2game12);
			_matchGames.push(Assets.match2game13);
			_matchGames.push(Assets.match2game14);
			
			
			_games = [];
			_games.push(Assets.match2game0);
			_games.push(Assets.bubble);
			_games.push(Assets.construct1);
			_games.push(Assets.sorting1);
			_games.push(Assets.sorting2);
			_games.push(Assets.bubble);
			_games.push(Assets.match2game1);
			_games.push(Assets.match2game2);
			_games.push(Assets.match2game3);
			_games.push(Assets.match2game4);
			_games.push(Assets.bubble);
			_games.push(Assets.match2game5);
			_games.push(Assets.match2game6);
			_games.push(Assets.match2game7);
			_games.push(Assets.bubble);
			_games.push(Assets.match2game8);
			_games.push(Assets.match2game9);
			_games.push(Assets.match2game10);
			_games.push(Assets.bubble);
			_games.push(Assets.match2game11);
			_games.push(Assets.match2game12);
			_games.push(Assets.match2game13);
			_games.push(Assets.bubble);
			_games.push(Assets.match2game14);
			
			super.onRegister();
			GameFacade.interfaceView = new InterfaceView(GameFacade.skin);
			GameFacade.gameView = new GameView();
			GameFacade.b2dEngine = new B2DController();
			GameFacade.nb2dEngine = new NB2DController();
		}
		
		
		public function getNextGameAsset():Object
		{
			if(_currentGameIndex + 1 <= _activeGames.length - 1) _currentGameIndex++;
			else _currentGameIndex = 0;
			currentGameType = _activeGames[_currentGameIndex].type;
			return _activeGames[_currentGameIndex];
			
		}

		public function setGameType($type:String):void
		{
			_currentGameIndex = -1;
			if($type == "constructGame") _activeGames = _constructGames;
			if($type == "sortingGame") _activeGames = _sortingGames;
			if($type == "bubblesGame") _activeGames = _bubblesGames;
			if($type == "piecesGame") _activeGames = _piecesGames;
			if($type == "matchGame") _activeGames = _matchGames;
			if($type == "autoGame") _activeGames = _games;
		}

		
		public function get currentGameType():String 
		{
			return _currentGameType;
		}
		
		public function set currentGameType(value:String):void 
		{
			_currentGameType = value;
		}
		
		
	}

}