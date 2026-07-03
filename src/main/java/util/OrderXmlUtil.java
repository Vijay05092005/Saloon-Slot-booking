package util;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OrderXmlUtil {

    public static class OrderItem {
        private final String productName;
        private final int quantity;
        private final int unitPrice;
        private final int subtotal;

        public OrderItem(String productName, int quantity, int unitPrice) {
            this.productName = productName;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.subtotal = quantity * unitPrice;
        }

        public String getProductName() {
            return productName;
        }

        public int getQuantity() {
            return quantity;
        }

        public int getUnitPrice() {
            return unitPrice;
        }

        public int getSubtotal() {
            return subtotal;
        }
    }

    public static class OrderRecord {
        private final String orderId;
        private final String createdAt;
        private final String customerName;
        private final String customerPhone;
        private final String customerAddress;
        private final String paymentMethod;
        private final String paymentStatus;
        private final String paymentDetails;
        private final int totalAmount;
        private final List<OrderItem> items;

        public OrderRecord(
                String orderId,
                String createdAt,
                String customerName,
                String customerPhone,
                String customerAddress,
                String paymentMethod,
                String paymentStatus,
                String paymentDetails,
                int totalAmount,
                List<OrderItem> items
        ) {
            this.orderId = orderId;
            this.createdAt = createdAt;
            this.customerName = customerName;
            this.customerPhone = customerPhone;
            this.customerAddress = customerAddress;
            this.paymentMethod = paymentMethod;
            this.paymentStatus = paymentStatus;
            this.paymentDetails = paymentDetails;
            this.totalAmount = totalAmount;
            this.items = items;
        }

        public String getOrderId() {
            return orderId;
        }

        public String getCreatedAt() {
            return createdAt;
        }

        public String getCustomerName() {
            return customerName;
        }

        public String getCustomerPhone() {
            return customerPhone;
        }

        public String getCustomerAddress() {
            return customerAddress;
        }

        public String getPaymentMethod() {
            return paymentMethod;
        }

        public String getPaymentStatus() {
            return paymentStatus;
        }

        public String getPaymentDetails() {
            return paymentDetails;
        }

        public int getTotalAmount() {
            return totalAmount;
        }

        public List<OrderItem> getItems() {
            return items;
        }
    }

    public static class NewOrderData {
        private final String customerName;
        private final String customerPhone;
        private final String customerAddress;
        private final String paymentMethod;
        private final String paymentStatus;
        private final String paymentDetails;
        private final int totalAmount;
        private final List<OrderItem> items;

        public NewOrderData(
                String customerName,
                String customerPhone,
                String customerAddress,
                String paymentMethod,
                String paymentStatus,
                String paymentDetails,
                int totalAmount,
                List<OrderItem> items
        ) {
            this.customerName = customerName;
            this.customerPhone = customerPhone;
            this.customerAddress = customerAddress;
            this.paymentMethod = paymentMethod;
            this.paymentStatus = paymentStatus;
            this.paymentDetails = paymentDetails;
            this.totalAmount = totalAmount;
            this.items = items;
        }
    }

    public static synchronized OrderRecord appendOrder(File xmlFile, NewOrderData orderData) throws Exception {
        Document document = loadOrCreateDocument(xmlFile);
        Element root = document.getDocumentElement();

        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String createdAt = java.time.LocalDateTime.now().toString();

        Element orderElement = document.createElement("order");
        orderElement.setAttribute("id", orderId);
        orderElement.setAttribute("createdAt", createdAt);

        Element customerElement = document.createElement("customer");
        addTextChild(document, customerElement, "name", orderData.customerName);
        addTextChild(document, customerElement, "phone", orderData.customerPhone);
        addTextChild(document, customerElement, "address", orderData.customerAddress);
        orderElement.appendChild(customerElement);

        Element paymentElement = document.createElement("payment");
        addTextChild(document, paymentElement, "method", orderData.paymentMethod);
        addTextChild(document, paymentElement, "status", orderData.paymentStatus);
        addTextChild(document, paymentElement, "details", orderData.paymentDetails);
        addTextChild(document, paymentElement, "totalAmount", String.valueOf(orderData.totalAmount));
        orderElement.appendChild(paymentElement);

        Element itemsElement = document.createElement("items");
        for (OrderItem item : orderData.items) {
            Element itemElement = document.createElement("item");
            addTextChild(document, itemElement, "productName", item.getProductName());
            addTextChild(document, itemElement, "quantity", String.valueOf(item.getQuantity()));
            addTextChild(document, itemElement, "unitPrice", String.valueOf(item.getUnitPrice()));
            addTextChild(document, itemElement, "subtotal", String.valueOf(item.getSubtotal()));
            itemsElement.appendChild(itemElement);
        }
        orderElement.appendChild(itemsElement);

        root.appendChild(orderElement);
        writeDocument(document, xmlFile);

        return new OrderRecord(
                orderId,
                createdAt,
                orderData.customerName,
                orderData.customerPhone,
                orderData.customerAddress,
                orderData.paymentMethod,
                orderData.paymentStatus,
                orderData.paymentDetails,
                orderData.totalAmount,
                new ArrayList<>(orderData.items)
        );
    }

    public static synchronized List<OrderRecord> readOrders(File xmlFile) throws Exception {
        List<OrderRecord> orders = new ArrayList<>();
        if (!xmlFile.exists()) {
            return orders;
        }

        Document document = parseDocument(xmlFile);
        NodeList orderNodes = document.getDocumentElement().getElementsByTagName("order");

        for (int i = orderNodes.getLength() - 1; i >= 0; i--) {
            Node node = orderNodes.item(i);
            if (node.getNodeType() != Node.ELEMENT_NODE) {
                continue;
            }

            Element orderElement = (Element) node;
            Element customerElement = getFirstChildElement(orderElement, "customer");
            Element paymentElement = getFirstChildElement(orderElement, "payment");
            Element itemsElement = getFirstChildElement(orderElement, "items");

            List<OrderItem> items = new ArrayList<>();
            if (itemsElement != null) {
                NodeList itemNodes = itemsElement.getElementsByTagName("item");
                for (int j = 0; j < itemNodes.getLength(); j++) {
                    Node itemNode = itemNodes.item(j);
                    if (itemNode.getNodeType() != Node.ELEMENT_NODE) {
                        continue;
                    }
                    Element itemElement = (Element) itemNode;
                    items.add(new OrderItem(
                            getChildText(itemElement, "productName"),
                            parseInt(getChildText(itemElement, "quantity")),
                            parseInt(getChildText(itemElement, "unitPrice"))
                    ));
                }
            }

            orders.add(new OrderRecord(
                    orderElement.getAttribute("id"),
                    orderElement.getAttribute("createdAt"),
                    getChildText(customerElement, "name"),
                    getChildText(customerElement, "phone"),
                    getChildText(customerElement, "address"),
                    getChildText(paymentElement, "method"),
                    getChildText(paymentElement, "status"),
                    getChildText(paymentElement, "details"),
                    parseInt(getChildText(paymentElement, "totalAmount")),
                    items
            ));
        }

        return orders;
    }

    private static Document loadOrCreateDocument(File xmlFile) throws Exception {
        if (xmlFile.exists()) {
            return parseDocument(xmlFile);
        }

        File parent = xmlFile.getParentFile();
        if (parent != null && !parent.exists()) {
            parent.mkdirs();
        }

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.newDocument();
        document.appendChild(document.createElement("orders"));
        writeDocument(document, xmlFile);
        return document;
    }

    private static Document parseDocument(File xmlFile) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.parse(xmlFile);
        document.getDocumentElement().normalize();
        return document;
    }

    private static void writeDocument(Document document, File xmlFile) throws Exception {
        removeWhitespaceNodes(document.getDocumentElement());
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
        transformer.transform(new DOMSource(document), new StreamResult(xmlFile));
    }

    private static void removeWhitespaceNodes(Node node) {
        NodeList children = node.getChildNodes();
        for (int i = children.getLength() - 1; i >= 0; i--) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.TEXT_NODE) {
                Text textNode = (Text) child;
                if (textNode.getData().trim().isEmpty()) {
                    node.removeChild(child);
                }
            } else if (child.getNodeType() == Node.ELEMENT_NODE) {
                removeWhitespaceNodes(child);
            }
        }
    }

    private static void addTextChild(Document document, Element parent, String tagName, String value) {
        Element child = document.createElement(tagName);
        child.setTextContent(value == null ? "" : value);
        parent.appendChild(child);
    }

    private static Element getFirstChildElement(Element parent, String tagName) {
        if (parent == null) {
            return null;
        }
        NodeList nodes = parent.getElementsByTagName(tagName);
        if (nodes.getLength() == 0) {
            return null;
        }
        return (Element) nodes.item(0);
    }

    private static String getChildText(Element parent, String tagName) {
        Element child = getFirstChildElement(parent, tagName);
        return child == null ? "" : child.getTextContent();
    }

    private static int parseInt(String value) {
        try {
            return Integer.parseInt(value == null ? "0" : value.trim());
        } catch (Exception ex) {
            return 0;
        }
    }
}
