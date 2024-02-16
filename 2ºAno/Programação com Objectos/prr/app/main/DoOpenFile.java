package prr.app.main;

import prr.core.NetworkManager;
import prr.app.exception.FileOpenFailedException;
import pt.tecnico.uilib.forms.Form;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
//Add more imports if needed

/**
 * Command to open a file.
 */
class DoOpenFile extends Command<NetworkManager> {

  DoOpenFile(NetworkManager receiver) {
    super(Label.OPEN_FILE, receiver);
    //FIXME add command fields
  }
  
  @Override
  protected final void execute() throws CommandException {
    /*
      try {
      //FIXME implement command
      } catch (UnavailableFileException | ClassNotFoundException e) {
        throw new FileOpenFailedException(e);
      }
    */  
  }
}
