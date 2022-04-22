package com.qsy.utils;

import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author qsy
 * @create 2022/3/29 - 10:51
 */
/*
* 对Data类型数据进行处理的工具类*/
public class DateUtils {
    /*
    * 对指定的Data类型对象进行格式化:yyyy-MM-dd HH:mm:ss*/
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(date);
        return dateStr;

    }
    /*
     * 对指定的Data类型对象进行格式化:yyyy-MM-dd*/
    public static String formatDate(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String dateStr = sdf.format(date);
        return dateStr;
    }
    /*
     * 对指定的Data类型对象进行格式化:HH:mm:ss*/
    public static String formatTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        String dateStr = sdf.format(date);
        return dateStr;
    }

    @Test
    public void test(){
        String str="1123";
        System.out.println(str.length());
    }
}
