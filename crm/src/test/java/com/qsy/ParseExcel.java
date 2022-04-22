package com.qsy;

import com.qsy.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.InputStream;

/**
 * 使用apachepoi 解析excel文件
 * @author qsy
 * @create 2022/4/4 - 11:16
 */
public class ParseExcel {
    @Test
    public void test() throws Exception{
        //根据excel文件生成HSSFWorkbook对象，封装了excel文件的所有信息
        FileInputStream in = new FileInputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\studentList.xls");
        HSSFWorkbook workbook = new HSSFWorkbook(in);
        //根据wb获取HSSFSheet对象，封装了一页的所有信息
        HSSFSheet sheet = workbook.getSheetAt(0);//根据页的下标获取页 从0开始 依次增加
        HSSFRow row=null;
        HSSFCell cell=null;
        for (int i = 0; i <=sheet.getLastRowNum(); i++) {//sheet.getLastRowNum()最后一行的下标
            //根据sheet获取HSSFRow对象，封装了一行的所有信息
            row=sheet.getRow(i); //通过行下标获取row，从0开始 依次增加

            for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum()最后一列的下标+1
                //根据row获取HSSFCell对象，封装了一列的所有信息
                cell = row.getCell(j);

                //获取列中数据
                System.out.print(HSSFUtils.getCellValueForStr(cell)+" ");
            }
            System.out.println();
        }

    }
}
