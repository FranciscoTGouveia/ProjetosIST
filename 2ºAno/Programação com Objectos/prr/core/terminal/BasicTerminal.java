package prr.core.terminal;

import prr.core.terminal.Terminal;
import prr.core.terminal.TerminalMode;
import prr.core.terminal.TerminalType;
import prr.core.Client;

public class BasicTerminal extends Terminal {
    public BasicTerminal(String id, TerminalType type, Client owner) {
        super(id,type,owner);
    }


}
