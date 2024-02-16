package prr.core.terminal;

import prr.core.Client;
import prr.core.Communication;
import java.io.Serializable;
import java.util.*;

// FIXME add more import if needed (cannot import from pt.tecnico or prr.app)

/**
 * Abstract terminal.
 */
abstract public class Terminal implements Serializable /* FIXME maybe addd more interfaces */ {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202208091753L;
  private String _id;
  private TerminalType _terminalType;
  private Client _owner;
  private List<Terminal> _terminalFriends;
  private double _debts;
  private double _payments;
  private TerminalMode _mode;
  private List<Communication> _madeComms;
  private List<Communication> _receivedComms;

  public Terminal(String id, TerminalType type, Client owner) {
    _id = id;
    _terminalType = type;
    _owner = owner;
  }

  /**
   * NetworkManager receive
   * Checks if this terminal can end the current interactive communication.
   *
   * @return true if this terminal is busy (i.e., it has an active interactive
   *         communication) and
   *         it was the originator of this communication.
   **/
  public boolean canEndCurrentCommunication() {
    return true;
    // FIXME add implementation code
  }

  /**
   * Checks if this terminal can start a new communication.
   *
   * @return true if this terminal is neither off neither busy, false otherwise.
   **/
  public boolean canStartCommunication() {
    return true;
    // FIXME add implementation code
  }

  public String getTerminalFriends() {
    // FIXME this can be more clean  
    String str = "";
    for (Terminal terminal : _terminalFriends) {
      str.concat(terminal.toString() + '|');
    }
    if (str.length() != 0)
      str.substring(0, str.length()-1);
    return str;
  }


  public boolean isUnused() {
    return _madeComms.isEmpty() && _receivedComms.isEmpty();
  }

  @Override
  public boolean equals(Object obj) {
    if (obj instanceof Terminal) {
      return _id == ((Terminal) obj)._id;
    }
    return false;
  }

  @Override
  public int hashCode() {
    return _id.hashCode();
  }

  @Override
  public String toString() {
    return _terminalType + "|" + _id + "|" + _owner.getKey() + "|" + _mode + "|" + _payments + "|" + _debts + "|" + getTerminalFriends();
  }
}
