package com.hydraframework.plugins.stateManager {

    import com.hydraframework.core.mvc.patterns.plugin.Plugin;
    import com.hydraframework.plugins.stateManager.events.StateEvent;

    import flash.events.Event;
    import flash.utils.setTimeout;

    import mx.collections.ArrayCollection;
    import mx.controls.treeClasses.ITreeDataDescriptor;
    import mx.events.BrowserChangeEvent;
    import mx.managers.BrowserManager;
    import mx.managers.IBrowserManager;

    public class StateManager extends Plugin implements IStateManager {
        /*
           --------------------------------------------------------------------

           Constants

           --------------------------------------------------------------------
         */

        public static const NAME:String = "StateManager";

//        private static const _instance:IStateManager = new StateManager();
//
//        public static function get instance():IStateManager {
//            trace("*** [HYDRA::StateManager.instance get]");
//            return _instance;
//        }

        public function StateManager() {
            super(NAME);
            bindBrowserManager();
        }

        /*
           --------------------------------------------------------------------

           Private fields

           --------------------------------------------------------------------
         */

        private var browserManager:IBrowserManager;
        private var parsing:Boolean     = false;

        /*
           --------------------------------------------------------------------

           Public Properties

           --------------------------------------------------------------------
         */

        private var _dataProvider:ITreeDataDescriptor;

        public function set dataProvider(value:ITreeDataDescriptor):void {
            trace("*** [HYDRA::StateManager.dataProvider set]");
            if (value != _dataProvider) {
                _dataProvider = value;
            }
        }

        public function get dataProvider():ITreeDataDescriptor {
            trace("*** [HYDRA::StateManager.dataProvider get]");
            return _dataProvider;
        }

        private var _keyField:String;

        public function set keyField(value:String):void {
            trace("*** [HYDRA::StateManager.keyField set]");
            if (value != _keyField) {
                _keyField = value;
            }
        }

        public function get keyField():String {
            trace("*** [HYDRA::StateManager.keyField get]");
            return _keyField;
        }

        private var _labelField:String;

        public function set labelField(value:String):void {
            trace("*** [HYDRA::StateManager.labelField set]");
            if (value != _labelField) {
                _labelField = value;
            }
        }

        public function get labelField():String {
            trace("*** [HYDRA::StateManager.labelField get]");
            return _labelField;
        }

        private var _dataField:String;

        public function set dataField(value:String):void {
            trace("*** [HYDRA::StateManager.dataField set]");
            if (value != _dataField) {
                _dataField = value;
            }
        }

        public function get dataField():String {
            trace("*** [HYDRA::StateManager.dataField get]");
            return _dataField;
        }

        private var _currentState:Object;

        public function get currentState():Object {
            trace("*** [HYDRA::StateManager.currentState get]");
            return _currentState;
        }

        /*
           --------------------------------------------------------------------

           Public API

           --------------------------------------------------------------------
         */

        public function setState(value:Object, updateHistory:Boolean = true):void {
            trace("*** [HYDRA::StateManager.setState]");
            if (value != _currentState) {
                _currentState = value;

                if (updateHistory) {
                    this.updateURL();
                }
                this.updateTitle();
                this.dispatchEvent(new StateEvent(StateEvent.STATE_CHANGE, _currentState));
            }
        }

        /*
           --------------------------------------------------------------------

           Private Methods

           --------------------------------------------------------------------
         */

        private function bindBrowserManager():void {
            browserManager = BrowserManager.getInstance();
            browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, parseURL);
            browserManager.init("", "");
        }

        private function updateTitle():void {
            browserManager.setTitle(_labelField);
        }

        private function updateURL():void {
            if (!parsing) {
                setTimeout(actuallyUpdateURL, 100);
            }
        }

        private function actuallyUpdateURL():void {
            browserManager.setFragment(escape(_keyField));
        }

        private function parseURL(event:Event):void {
            parsing = true;
            var view:String = unescape(browserManager.fragment as String);
            loadState(view as String);
            parsing = false;
        }

        private function retrieveStateByKey(key:String, node:Object = null):Object {
            if (!node) {
                node = _dataProvider;
            }
            if (node.hasOwnProperty(_keyField)) {
                if (node[_keyField] == key) {
                    return node;
                } else {
                    if (_dataProvider.hasChildren(node)) {
                        var children:ArrayCollection = ArrayCollection(_dataProvider.getChildren(node));
                        var state:Object;
                        for each (var child:Object in children) {
                            state = retrieveStateByKey(key, child);
                            if (state) {
                                return state;
                            }
                        }
                    }
                }
            }
            return null;
        }

        private function loadState(key:String):void {
            if (!this._dataProvider) {
                setTimeout(loadState, 500, key);
                return;
            }

            var state:Object = retrieveStateByKey(key);
            setState(state, false);
        }
    }
}
