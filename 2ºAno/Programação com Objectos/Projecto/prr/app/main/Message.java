package prr.app.main;

/**
 * Messages.
 */
interface Message {

  /**
   * @return string with "file not found" message.
   */
  static String fileNotFound() {
    return "O ficheiro não existe.";
  }
  
  /**
   * @param filename
   * @return string with "file not found" message (more elaborate).
   */
  static String fileNotFound(String filename) {
    return "O ficheiro '" + filename + "' não existe.";
  }
  
  /**
   * @param payments
   * @param debts
   * @return string presenting message
   */
  static String globalPaymentsAndDebts(long payments, long debts) {
    return "Valores globais: " + payments + " (pagamentos),  " + debts + " (dívidas).";
  }

  /** @return string with prompt for filename to open. */
  static String openFile() {
    return "Ficheiro a abrir: ";
  }
  
  /** @return string with a warning and a question. */
  static String newSaveAs() {
    return "Ficheiro sem nome. " + saveAs();
  }
  
  /** @return string asking for a filename. */
  static String saveAs() {
    return "Guardar ficheiro como: ";
  }
  
  /** @return string confirming that user wants to save. */
  static String saveBeforeExit() {
    return "Guardar antes de fechar? ";
  }
  
  /** @return string prompting for the number of days to advance (integer). */
  static String daysToAdvance() {
    return "Número de dias a avançar: ";
  }
}
