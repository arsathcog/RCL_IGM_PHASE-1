/*
 * @(#)AccessControl.java
 *
 * Copyright 2001 by NIIT,
 * All rights reserved.
 * 
 * This software is the confidential and proprietary information
 * of NIIT. ("Confidential Information").  
 */

package com.rclgroup.dolphin.ezl.resource;

import com.niit.control.common.Debug;
import com.niit.control.common.GlobalConstants;
import com.niit.control.web.UserAccountBean;
import com.niit.control.web.action.BaseAction;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * @version     1.0
 * @author NIIT
 */
public class AccessControl extends org.apache.struts.action.ActionServlet implements GlobalConstants  {

    
    public static final String QUERY_STR  = "?";
    public static final String EQUAL      = "=";
    public static final String MENU       = "MENU";
    public static final String DO         = "/do/";
    public static final String HOME       = "/home";
    public static final String REPORT_URL = "/openReport";
    public static final String SCREEN_ID  = "/screenId";
    public static final String SECM002 = "SECM002";
    public static final String SECM004 = "SECM004";
    public static final String ENOTICE = "ENOTICE";
    
    

    
    /**
    * @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
    */
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        doPost(req,resp);
    }
    
    

    /**
    * @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
    */
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        RequestDispatcher lobjReqDisp  = null;
        StringBuffer      lstbNextScrId= null;
        String            lstrScreenId = null;
        
        UserAccountBean   account      = null;
        HttpSession       session      = req.getSession(true);
        
        
        
        String            lstrPathInfo = req.getPathInfo();
        
        
        String            lstrQueryString =req.getQueryString();
        
        int               lintLength   = lstrPathInfo.length();
        
    
        
         
        try {
            Debug.logFramework("Access Control-" + req.getLocalName() + COLON + 
                                req.getLocalPort() + COMMA + req.getPathInfo());
            Debug.logFramework("lstrQueryString="+lstrQueryString);
            Debug.logFramework("req.getRequestURI()="+req.getRequestURI());
            Debug.logFramework("req.getRequestURL()="+req.getRequestURL());
            Debug.logFramework("req.getPathInfo()="+lstrPathInfo);
            
            if( lintLength > SCREEN_SIZE ) {
                lintLength = SCREEN_SIZE;
            }
            //Extract Screen ID (ex. SVCT001)
            lstrScreenId = lstrPathInfo.substring(1,lintLength).toUpperCase();
                        
            Debug.logFramework("lstrScreenId="+lstrScreenId); 
            
            if(lstrScreenId.equalsIgnoreCase("SIGM001")){
                UserAccountBean userBean = new UserAccountBean();
                userBean.setUserFsc("PUBLIC_USER");
                userBean.setFscAccessLevels("*");
                userBean.setUserFsc("R");
                userBean.setUserId("00000");
                userBean.setUserName("PUBLIC USER");
                session.setAttribute(USER_ACCOUNT_BEAN,userBean);
                super.doPost(req, resp);   
                return;
            }
            
            account = (UserAccountBean) session.getAttribute(USER_ACCOUNT_BEAN);
            if(account== null){
                Debug.logFramework("UAB is NUll Close me"); 
                getServletConfig().getServletContext().getRequestDispatcher(NO_SESSION_PATH).forward(req,resp);
                return;
            }
            
            if ( lstrPathInfo.equals(HOME) 
                        || lstrPathInfo.equals(REPORT_URL)
                        || lstrPathInfo.equals(SCREEN_ID)
                        || lstrScreenId != null && lstrScreenId.equals(SECM002)
                        || lstrScreenId != null && lstrScreenId.equals(SECM004)
                        || lstrScreenId != null && lstrScreenId.equals(ENOTICE)
                        || lstrScreenId != null && lstrScreenId.equals("SETW001")
                        || lstrScreenId != null && lstrScreenId.equalsIgnoreCase("SIGM001")
                        || lstrScreenId != null && lstrScreenId.equalsIgnoreCase("JIGM001")
                        || lstrScreenId != null && lstrScreenId.equalsIgnoreCase("IGM001")
                        ) {
                Debug.logFramework("No Auth Check required for some pages...");	
                super.doPost(req, resp);   
                return;
            } else if (lstrScreenId != null){
                Debug.logFramework("Checking screen authorization for "+lstrScreenId);
                /* Do authorization check */
                if(!BaseAction.hasScreenAccess(account, lstrScreenId)){
                    Debug.logFramework("Not Authorized this screen to view"); 
                    getServletConfig().getServletContext().getRequestDispatcher(NO_AUTH_PATH).forward(req,resp);
                } else {
                    super.doPost(req, resp);
                }
                return;
            } else {
                Debug.logFramework("Fits to No Other known if-else...so error"); 
                getServletConfig().getServletContext().getRequestDispatcher(NO_AUTH_PATH).forward(req,resp);
                return;
            }
            
        } catch (Exception ex) {
		Debug.logFramework("Error in do post - access control"); 	
                Debug.logFramework(ex);
                ex.printStackTrace();
                getServletConfig().getServletContext().getRequestDispatcher(ERROR_PATH).forward(req, resp);
        }        

    }


    /**
    * @see javax.servlet.GenericServlet#void ()
    */
    public void init() throws ServletException {

        super.init();

    }

}
/* Modification History
 *
 * 2005-07: Modified for Tops
 * 2009-11: Moified for EZL
 *
 */
