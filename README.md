# 🚢 GlobalTrade Logistics Management System

![Java](https://img.shields.io/badge/Java-21-orange?style=flat-square&logo=java)
![Jakarta EE](https://img.shields.io/badge/Jakarta_EE-10-blue?style=flat-square&logo=eclipse)
![Payara Server](https://img.shields.io/badge/Payara_Server-6-yellow?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=flat-square&logo=mysql)
![Mockito](https://img.shields.io/badge/Tested_with-JUnit5_%7C_Mockito-green?style=flat-square)

An enterprise-grade supply chain and logistics modernization platform. Built to handle complex international trade operations, this system replaces legacy tracking tools with a robust, scalable, and highly secure architecture using **Enterprise JavaBeans (EJB)** and **Jakarta EE**.

---

**✨ Core Features**

* **Automated Timer Services:** Daily inventory monitoring and 30-minute interval shipment deadline tracking using non-persistent `@Schedule` EJB timers for optimized database I/O.
* **Advanced Transaction Management:** Hybrid CMT (Container-Managed) for routine operations and BMT (Bean-Managed) via `UserTransaction` for critical stock adjustments.
* **Logistics Interceptor Framework:** Transparent audit trails and operational logging using `@AroundInvoke` for global regulatory compliance.
* **Multi-Layered Security:** Role-Based Access Control (RBAC) covering 5 user roles via container-managed security (`j_security_check`) and stateless **JWT** for customer tracking APIs.
* **Resilient Exception Handling:** Custom `@ApplicationException(rollback = true)` for safe transaction aborts during supply chain failures (e.g., `InsufficientInventoryException`).

**🛠️ Technology Stack**

* **Backend:** Java 21, Jakarta EE 10, EJB (`@Stateless`, `@Singleton`)
* **Persistence:** JPA / Hibernate 6, MySQL 8.0
* **Web/API Tier:** JAX-RS (REST APIs), Servlets, JSP, Bootstrap 5
* **Testing:** JUnit 5, Mockito, Apache JMeter, Postman
* **Deployment:** Payara Server 6, Maven

**📦 Enterprise Architecture**

The project follows a strict multi-module Maven split-directory structure to ensure separation of concerns:
* `globaltrade-ear/` : Enterprise Archive for application-wide deployment.
* `globaltrade-ejb/` : Core business logic, Entities, Timers, Interceptors, and isolated Mockito Unit Tests.
* `globaltrade-web/` : Presentation tier, JAX-RS endpoints, and security filters.

**🚀 Getting Started**

**Prerequisites**
* JDK 21+
* Apache Maven 3.8+
* MySQL 8.0
* Payara Server 6.x / GlassFish

**Installation & Setup**
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/yourusername/Globaltrade-Logistics-System.git](https://github.com/Dulanka-Deshanjali/Globaltrade-Logistics-System.git)
