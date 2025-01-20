package nz.net.osnz.appengine;

import com.google.appengine.api.utils.SystemProperty;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
public class App {

    public static Map<String, String> getInfo() {
        Map<String, String> data = new HashMap<String, String>();
        data.put("version", System.getProperty("java.version"));
        data.put("os", System.getProperty("os.name"));
        data.put("user", System.getProperty("user.name"));
        data.put("application_id", System.getProperty("APPLICATION_ID"));
        data.put("app.system.property", System.getProperty("app.system.property"));
        data.put("project_id", SystemProperty.applicationId.get());

        return data;
    }

//    public static String getInfo() {
//        return "Hello world";
//    }

}
