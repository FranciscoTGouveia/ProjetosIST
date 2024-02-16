package prr.core.terminal;

import prr.core.terminal.Terminal;
import prr.core.terminal.TerminalMode;
import prr.core.terminal.TerminalType;
import prr.core.Client;

public class FancyTerminal extends Terminal {
    public FancyTerminal(String id, TerminalType type, Client owner) {
        super(id,type,owner);
    }
}
