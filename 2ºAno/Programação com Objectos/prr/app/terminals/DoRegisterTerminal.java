package prr.app.terminals;

import prr.app.exception.*;
import prr.core.Network;
import prr.core.terminal.TerminalType;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
//FIXME add more imports if needed

/**
 * Register terminal.
 */
class DoRegisterTerminal extends Command<Network> {

  DoRegisterTerminal(Network receiver) {
    super(Label.REGISTER_TERMINAL, receiver);
    addStringField("idTerminal",Message.terminalKey());
    addStringField("type",Message.terminalType());
    addStringField("idClient", Message.clientKey());
    //FIXME add command fields
  }

  @Override
  protected final void execute() throws CommandException {
    String idTerminal = stringField("idTerminal");
    String idClient = stringField("idClient");
    String type = stringField("type");
    TerminalType terminalType;
    if (type == "BASIC") { // Here we can throw a custom exception for invalid types so 
                            // it can be handled in regitsrTerminal
      terminalType = TerminalType.BASIC;
    }
    else {                              // Probably a better way to do this 
      terminalType = TerminalType.FANCY;
    }
    try {
      _receiver.registerTerminal(idTerminal, terminalType, idClient);
    } catch (InvalidTerminalKeyException ex) {
      throw new InvalidTerminalKeyException(idTerminal);
    }
    catch (DuplicateTerminalKeyException ex) {
      throw new DuplicateTerminalKeyException(idTerminal);
    }
    catch (UnknownClientKeyException ex) {
      throw new UnknownClientKeyException(idClient);
    }
    
    //FIXME implement command
  }
}
