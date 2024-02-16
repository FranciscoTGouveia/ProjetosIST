package prr.app.client;

import prr.core.Network;
import prr.app.exception.UnknownClientKeyException;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
//FIXME add more imports if needed

/**
 * Show specific client: also show previous notifications.
 */
class DoShowClient extends Command<Network> {

  DoShowClient(Network receiver) {
    super(Label.SHOW_CLIENT, receiver);
    addStringField("key", Message.key());
    //FIXME add command fields
  }

  @Override
  protected final void execute() throws CommandException {
    String key = stringField("key");
    try {
      _display.popup(_receiver.showClient(key));
    } catch (UnknownClientKeyException ex) {
      throw new UnknownClientKeyException(key);
    }
  }
}
