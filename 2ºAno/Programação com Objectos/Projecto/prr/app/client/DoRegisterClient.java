package prr.app.client;

import prr.core.Network;
import prr.app.exception.DuplicateClientKeyException;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
//FIXME add more imports if needed

/**
 * Register new client.
 */
class DoRegisterClient extends Command<Network> {

  DoRegisterClient(Network receiver) {
    super(Label.REGISTER_CLIENT, receiver);
    addStringField("key",Message.key());
    addStringField("name", Message.name());
    addIntegerField("tax", Message.taxId());

    //FIXME add command fields
  }
  
  @Override
  protected final void execute() throws CommandException {
    String key = stringField("key");
    String name = stringField("name");
    Integer tax = integerField("tax");
    try {
      _receiver.registerClient(key,name,tax);
    } catch (DuplicateClientKeyException ex) {
      throw new DuplicateClientKeyException(key);
    }
   
    //FIXME implement command
  }
}
