package com.qsy.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.CellType;

import java.text.DecimalFormat;

/**
 * 关于excel文件操作的工具类
 */
public class HSSFUtils {
    /**
     * 从指定的HSSFCell对象中获取列的值
     * @return
     */
    public static String getCellValueForStr(HSSFCell cell){
        String ret="";
        switch (cell.getCellType()){
            case STRING:
                ret=cell.getStringCellValue();
                break;
            case BOOLEAN:
                ret=cell.getBooleanCellValue()+"";
                break;
            case NUMERIC:
                // 格式化科学计数法，取一位整数
                DecimalFormat df = new DecimalFormat("0");
                ret=df.format(cell.getNumericCellValue());
                break;
            case FORMULA:
                ret=cell.getCellFormula()+"";
                break;
            case BLANK:
            case ERROR:
            case _NONE:
                ret="";
                break;
            default:
                break;


        }

        return ret;
    }
}

