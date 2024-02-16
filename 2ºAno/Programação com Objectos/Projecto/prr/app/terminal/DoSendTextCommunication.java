package prr.app.terminal;

import prr.core.Network;
import prr.core.terminal.Terminal;
import pt.tecnico.uilib.menus.CommandException;
//FIXME add more imports if needed

/**
 * Command for sending a text communication.
 */
class DoSendTextCommunication extends TerminalCommand {

  DoSendTextCommunication(Network context, Terminal terminal) {
    super(Label.SEND_TEXT_COMMUNICATION, context, terminal, receiver -> receiver.canStartCommunication());
  }
  
  @Override
  protected final void execute() throws CommandException {
    //FIXME implement command
  }
} 
