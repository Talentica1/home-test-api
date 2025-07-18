package com.hometest.api;

import com.intuit.karate.junit5.Karate;

/**
 * Legacy test runner for backward compatibility
 * @deprecated Use InventoryTestSuite for enhanced functionality
 */
@Deprecated
class InventoryApiTest {

    @Karate.Test
    Karate testInventoryApi() {
        return Karate.run("classpath:features/inventory")
                .relativeTo(getClass());
    }
} 