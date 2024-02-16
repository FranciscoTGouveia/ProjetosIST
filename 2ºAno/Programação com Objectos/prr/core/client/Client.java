package prr.core;

import prr.core.terminal.Terminal;
import java.util.ArrayList;
import java.util.List;


public class Client {
    private String _key;
    private String _name;
    private ClientLevel _level;
    private int _taxNumber;
    private List<Terminal> _terminals;
    private NotificationMode _receiveNotifications;
    private int _payments;
    private int _debts;
    
    public Client(String id, String name, int tax) {
        _key = id;
        _name = name;
        _taxNumber = tax;
        _level = ClientLevel.NORMAL;
        _receiveNotifications = NotificationMode.YES;
        _terminals = new ArrayList<>();
    }



    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Client) {
            return _key == ((Client) obj)._key;
        }
        return false;
    }

    @Override
    public String toString() { // To be dealt with
        return "CLIENT" + "|" + _key + "|"+  _name + "|" + _taxNumber + "|" + _level + "|"
                + _receiveNotifications + "|" + _terminals.size() + "|" + _payments + "|"
                + _debts;
    }
    
    public void addTerminal(Terminal newTerminal) {
        _terminals.add(newTerminal);
    }
    
    public String getKey() {
        return _key;
    }
}
