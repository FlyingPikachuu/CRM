package com.qsy.utils;

import org.junit.Test;

import java.util.Scanner;
import java.util.UUID;

/**
 * @author qsy
 * @create 2022/3/31 - 11:08
 */
public class IDUtils {
    public static String getId() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }


    @Test
    public void test() {
        System.out.println(IDUtils.getId());

    }

}