package com.bhanuka.cms;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;

import java.io.File;

public class Main {
    public static void main(String[] args) {
        try {
            Tomcat tomcat = new Tomcat();
            tomcat.setPort(8090);
            tomcat.getConnector();

            tomcat.getHost().setAppBase(".");
            String webappDir = new File("web").getAbsolutePath();
            Context ctx = tomcat.addWebapp("", webappDir);
            System.out.println(webappDir);

            tomcat.start();
            System.out.println("Tomcat started at http://localhost:8090");
            tomcat.getServer().await();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}