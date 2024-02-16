package prr.app.lookup;

import java.util.*;
import prr.core.Network;
import prr.core.terminal.Terminal;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
//FIXME add more imports if needed

/**
 * Show unused terminals (without communications).
 */
class DoShowUnusedTerminals extends Command<Network> {

	DoShowUnusedTerminals(Network receiver) {
		super(Label.SHOW_UNUSED_TERMINALS, receiver);
	}

	@Override
	protected final void execute() throws CommandException {
		List<Terminal> terminalList = _receiver.showAllTerminals();
		for (Terminal terminal : terminalList) {
			if (terminal.isUnused()) {
				_display.addLine(terminal);
			}
		}
		_display.display();
	}
}
