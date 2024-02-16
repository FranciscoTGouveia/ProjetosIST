package prr.core;

import java.io.Serializable;
import java.io.IOException;
import java.util.*;

import prr.core.terminal.BasicTerminal;
import prr.core.terminal.FancyTerminal;
import prr.core.terminal.Terminal;
import prr.core.terminal.TerminalMode;
import prr.core.terminal.TerminalType;
import prr.core.exception.*;
import prr.app.exception.*;


// FIXME add more import if needed (cannot import from pt.tecnico or prr.app)

/**
 * Class Store implements a store.
 */
public class Network implements Serializable {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202208091753L;
  
  // FIXME define attributes
  // FIXME define contructor(s)
  // FIXME define methods
  private Set<Terminal> _terminals;
  private Map<String,Client> _clients;

  public Network() {
    _terminals = new HashSet<>();
    _clients = new HashMap<>();
  }


  public List<Terminal> showAllTerminals(){
    return new ArrayList<Terminal>(_terminals);
  }



  // FIXME Need to fix the exceptions
  public void registerTerminal(String id, TerminalType type, String clientId) throws InvalidTerminalKeyException, DuplicateTerminalKeyException, UnknownClientKeyException{
      Terminal newTerminal;
      Client owner = _clients.get(clientId);
      if (id.length() != 6) { // We also need to check if it only contains numbers
        throw new InvalidTerminalKeyException(id);
      }
      if (owner == null) {
          throw new UnknownClientKeyException(clientId);
      }
      switch (type) { // By default we create a basic terminal so we can check this exception 
                    // Better solution create a new exception for invalid type
                    // Another exception is to see if the client actually exists
        case BASIC -> newTerminal = new BasicTerminal(id,type,owner);

        case FANCY -> newTerminal = new FancyTerminal(id,type,owner);

        default -> newTerminal = new BasicTerminal(id,type,owner);
      }
      if (!_terminals.add(newTerminal)) { //If we cant add its because we have a duplicate
        throw new DuplicateTerminalKeyException(id);
      }
      owner.addTerminal(newTerminal);

    }
  
  
  public Client showClient(String key) throws UnknownClientKeyException{
    if (!_clients.containsKey(key)) {
      throw new UnknownClientKeyException(key);
    }
    return _clients.get(key);
  }
  
  public List<Client> showAllClients() {
    return new ArrayList<>(_clients.values());
  }

  public void registerClient(String key,String name,int tax) throws DuplicateClientKeyException{
      if (_clients.containsKey(key)) {
        throw new DuplicateClientKeyException(key);
      }
    Client newClient = new Client(key,name,tax);
    _clients.put(key,newClient);
  }
  
  
  /**
   * Read text input file and create corresponding domain entities.
   * 
   * @param filename name of the text input file
   * @throws UnrecognizedEntryException if some entry is not correct
   * @throws IOException if there is an IO erro while processing the text file
   */
  void importFile(String filename) throws UnrecognizedEntryException, IOException /* FIXME maybe other exceptions */  {
    //FIXME implement method
  }
}

