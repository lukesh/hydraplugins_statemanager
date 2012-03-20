package com.hydraframework.plugins.stateManager {

    import com.hydraframework.core.mvc.interfaces.IPlugin;

    import mx.controls.treeClasses.ITreeDataDescriptor;

    public interface IStateManager extends IPlugin {

        ////////////////////////////////////////////////////////////////
        //
        // Properties
        //
        ////////////////////////////////////////////////////////////////

        function set dataProvider(value:ITreeDataDescriptor):void;
        function get dataProvider():ITreeDataDescriptor;

        function set keyField(value:String):void;
        function get keyField():String;

        function set labelField(value:String):void;
        function get labelField():String;

        function set dataField(value:String):void;
        function get dataField():String;

        function get currentState():Object;

        ////////////////////////////////////////////////////////////////
        //
        // Methods
        //
        ////////////////////////////////////////////////////////////////
        function setState(value:Object, updateHistory:Boolean = true):void;
        /**
         * Move forward in the browser history. 'null' will be returned when at end
         */
        function forward():String;
        /**
         * Move backward in the browser history. 'null' will be returned when at beginning
         */
        function backward():String;
    }
}
