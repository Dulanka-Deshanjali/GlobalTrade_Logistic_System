package lk.logistic.interceptor;

import jakarta.interceptor.AroundInvoke;
import jakarta.interceptor.InvocationContext;

import java.util.logging.Logger;

public class LogisticsAuditInterceptor {

    private static final Logger logger = Logger.getLogger(LogisticsAuditInterceptor.class.getName());
    
    
    @AroundInvoke
    public Object logMethodEntry(InvocationContext context) throws Exception {

        String name = context.getMethod().getName();
        String className = context.getTarget().getClass().getName();

        logger.info("[AUDIT LOG] Executing method: " + name + " in class: " + className);


        Object result = context.proceed();

        logger.info("[AUDIT LOG] Method " + name + " executed successfully.");
        return result;
    }
    

}
