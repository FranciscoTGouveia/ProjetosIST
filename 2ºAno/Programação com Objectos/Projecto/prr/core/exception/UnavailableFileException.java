package prr.core.exception;

/**
 * 
 */
public class UnavailableFileException extends Exception {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202208091753L;
  
  /** The requested filename. */
  String _filename;
  
  /**
   * @param filename 
   */
  public UnavailableFileException(String filename) {
    _filename = filename;
  }
  
  /**
   * @return the requested filename
   */
  public String getFilename() {
    return _filename;
  }
}
