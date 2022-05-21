package com.qsy.utils;

import org.apache.commons.lang3.StringUtils;


import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

/**
 * @author qsy
 * @create 2022/5/15 - 8:18
 */
public class MyStringUtils {
    /**
     * 获取两个字符串的并集(去重后取并集)
     */
    public static String getUnion(String str1,String str2,String regex) {
        if (StringUtils.isEmpty(str1) || StringUtils.isEmpty(str2)) {
            return StringUtils.isEmpty(str1) ? str2 : str1;
        }
        HashSet<String> set = new HashSet<>();
        for (String s : str1.split(regex)) {
            set.add(s);
        }
        for (String s : str2.split(regex)) {
            set.add(s);
        }
//        String[] ret = {};

        return String.join(",",set);
    }
    public static String[] getUnionTest(String str1,String str2,String regex) {
//        if (StringUtils.isEmpty(str1) || StringUtils.isEmpty(str2)) {
//            return StringUtils.isEmpty(str1) ? str2 : str1;
//        }
        HashSet<String> set = new HashSet<>();
        for (String s : str1.split(regex)) {
            set.add(s);
        }
        for (String s : str2.split(regex)) {
            set.add(s);
        }
        String[] ret = {};
        return set.toArray(ret);
    }
    public static String stringListUnionRet(List<String> stringList){
        String retString = null;
        if(stringList!=null&&stringList.size()>0){
            if(stringList.size()==1){
                retString = stringList.get(0);
            }else{
                retString =  stringList.get(0);
                for (int i = 1; i < stringList.size(); i++) {
                    retString = MyStringUtils.getUnion(retString, stringList.get(i), ",");
                }
            }
        }
        return  retString;
    }


}
