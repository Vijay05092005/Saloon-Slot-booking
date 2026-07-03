import java.io.File;
import util.OrderXmlUtil;

public class XmlRewrite {
    public static void main(String[] args) throws Exception {
        File file = new File("data/orders.xml").getCanonicalFile();
        OrderXmlUtil.readOrders(file);
        java.lang.reflect.Method method = OrderXmlUtil.class.getDeclaredMethod("loadOrCreateDocument", File.class);
        method.setAccessible(true);
        org.w3c.dom.Document document = (org.w3c.dom.Document) method.invoke(null, file);
        java.lang.reflect.Method writeMethod = OrderXmlUtil.class.getDeclaredMethod("writeDocument", org.w3c.dom.Document.class, File.class);
        writeMethod.setAccessible(true);
        writeMethod.invoke(null, document, file);
    }
}
