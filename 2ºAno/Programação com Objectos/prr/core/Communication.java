package prr.core;

import prr.core.terminal.Terminal;

abstract public class Communication {
    private int _id;
    private boolean _ispaid;
    protected double _cost;
    protected boolean _isOngoing;
    private Terminal _to;
    private Terminal _form;

}
