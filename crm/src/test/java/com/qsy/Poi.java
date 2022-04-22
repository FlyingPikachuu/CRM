package com.qsy;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.FileOutputStream;
import java.io.OutputStream;

/**
 * @author qsy
 * @create 2022/4/3 - 11:31
 * 使用apache-poi生成excel文件
 */
public class Poi {
    @Test
    public void testCreateExcel() throws Exception{
        //创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook workbook = new HSSFWorkbook();
        //使用对象创建HSSFSheet对象，对应workbook文件中的一页
        HSSFSheet sheet = workbook.createSheet("学生列表");
        //使用sheet创建HSSFRow对象，对应sheet中的一行
        HSSFRow row = sheet.createRow(0);//参数为行号，从0开始,依次增加
        //使用row创建列对象，对应row中一列
        HSSFCell cell=row.createCell(0);//参数行的列号——第几个单元格，从0开始,依次增加
        cell.setCellValue("学号");
        cell=row.createCell(1);
        cell.setCellValue("姓名");
        cell=row.createCell(2);
        cell.setCellValue("年龄");

        //生成HSSFCellStyle对象
        HSSFCellStyle hssfCellStyle = workbook.createCellStyle();
        hssfCellStyle.setAlignment(HorizontalAlignment.CENTER);

        //使用sheet创建10个HSSFRow对象，对象sheet中10行
        for (int i = 1; i <=10; i++) {
            row=sheet.createRow(i);

            cell=row.createCell(0);
            cell.setCellValue(100+i);
            cell=row.createCell(1);
            cell.setCellValue("name"+i);
            cell=row.createCell(2);
            cell.setCellStyle(hssfCellStyle);
            cell.setCellValue(20+i);
        }
        //调用工具函数生成excel文件
//        流相比 file对象效率更高
        FileOutputStream stream = new FileOutputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\serverDir\\studentList.xls");
        //目录必须手动创建，文件可以自动创建
        workbook.write(stream);
        //关闭资源
        stream.close();
        workbook.close();

        System.out.println("========OK===========");
    }
    @Test
    public void test2() throws Exception{
        //创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook wb=new HSSFWorkbook();
        //使用wb创建HSSFSheet对象，对应wb文件中的一页
        HSSFSheet sheet=wb.createSheet("学生列表");
        //使用sheet创建HSSFRow对象，对应sheet中的一行
        HSSFRow row=sheet.createRow(0);//行号：从0开始,依次增加
        //使用row创建HSSFCell对象，对应row中的列
        HSSFCell cell=row.createCell(0);//列的编号：从0开始，依次增加
        cell.setCellValue("学号");
        cell=row.createCell(1);
        cell.setCellValue("姓名");
        cell=row.createCell(2);
        cell.setCellValue("年龄");

        //生成HSSFCellStyle对象
        HSSFCellStyle style=wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);

        //使用sheet创建10个HSSFRow对象，对应sheet中的10行
        for(int i=1;i<=10;i++){
            row=sheet.createRow(i);

            cell=row.createCell(0);//列的编号：从0开始，依次增加
            cell.setCellValue(100+i);
            cell=row.createCell(1);
            cell.setCellValue("NAME"+i);
            cell=row.createCell(2);
            cell.setCellStyle(style);
            cell.setCellValue(20+i);
        }

        //调用工具函数生成excel文件
        OutputStream os=new FileOutputStream("C:\\Users\\FlyingPikachu\\Desktop\\自学\\CRM——第一个WEB项目\\生成的excel\\student.xls");//目录必须手动创建，文件如果不存在，poi会自动创建
        wb.write(os);

        //关闭资源
        os.close();
        wb.close();

        System.out.println("===========create ok==========");
    }
}
