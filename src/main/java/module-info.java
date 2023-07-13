module com.javafx.actionsgradledemo {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.javafx.actionsgradledemo to javafx.fxml;
    exports com.javafx.actionsgradledemo;
}