package com.hometest.api;

import com.intuit.karate.junit5.Karate;

/**
 * Comprehensive test suite for Inventory API
 * Runs all inventory-related tests with proper organization
 */
class InventoryTestSuite {

    @Karate.Test
    Karate smokeTests() {
        return Karate.run("classpath:features/inventory")
                .tags("@smoke")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate criticalTests() {
        return Karate.run("classpath:features/inventory")
                .tags("@critical")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate getInventoryTests() {
        return Karate.run("classpath:features/inventory/get-inventory.feature")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate filterInventoryTests() {
        return Karate.run("classpath:features/inventory/filter-inventory.feature")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate addInventoryTests() {
        return Karate.run("classpath:features/inventory/add-inventory.feature")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate validationTests() {
        return Karate.run("classpath:features/inventory")
                .tags("@validation")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate performanceTests() {
        return Karate.run("classpath:features/inventory")
                .tags("@performance")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate securityTests() {
        return Karate.run("classpath:features/inventory")
                .tags("@security")
                .relativeTo(getClass());
    }

    @Karate.Test
    Karate allInventoryTests() {
        return Karate.run("classpath:features/inventory")
                .relativeTo(getClass());
    }
} 