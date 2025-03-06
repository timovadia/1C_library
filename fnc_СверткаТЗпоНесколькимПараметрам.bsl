////тзМояТаблица.Свернуть("ИмяКолонки1,ИмяКолонки2,ИмяКолонки3,ИмяКолонки4", "ИмяКолонки5");
////Думал, что в "ИмяКолонки1" должны быть уникальные значения.
////Однако. Уникальными будут сочетания значений всех четырех колонок.

////Свернуть (GroupBy)

////Синтаксис:
////Свернуть(<КолонкиГруппировок>, <КолонкиСуммирования>)
////Параметры: 
////<КолонкиГруппировок> (обязательный) Тип: Строка. Имена колонок, разделенные запятыми, по которым необходимо группировать строки табличного поля.
////<КолонкиСуммирования> (необязательный) Тип: Строка. Имена колонок, разделенные запятыми, по которым необходимо суммировать значения в строках табличного поля.

////Описание:
////Осуществляет свертку табличной части по указанным колонкам группировки. Строки, у которых совпадают значения в колонках, указанных в первом параметре, сворачиваются в одну строку. 
////Значения этих строк, хранящиеся в колонках, указанных во втором параметре, накапливаются. 
////Важно! Оба списка колонок должны покрывать всю табличную часть. Списки колонок не должны пересекаться.


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Свертка по более чем 2-м параметрам
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
list_СписокПараметров = "f_инструмент, f_инструмент_код, f_сделка_контрагент, f_сделка_контрагент_ИНН, f_сделка_контрагент_страна," + 
									" f_котировка, f_котировкаВалюта, f_НормативКраткосрочнойЛиквидностиБрокера, f_движениеДС, f_изОплаты, f_ставкаРиска, f_приход, f_расход";

new_wvTbl_сделки_Result = fnc_СверткаТЗпоНесколькимПараметрам( НайденныеСтроки_new_wvTbl_BO_РЕПО_сделки, list_СписокПараметров, 
														"f_инструмент_код", "f_движениеДС,f_изОплаты", "f_приход" );


/// НайденныеСтроки_new_wvTbl_BO_РЕПО_сделки <=> a_tValueTable -- таблица значений (ТЗ)
/// list_СписокПараметров <=> a_listParameters -- полный список параметров (колонок) ТЗ
/// "f_инструмент_код" <=> a_keyParameter -- параметр-ключ
/// "f_движениеДС,f_изОплаты" <=> a_columnsValues -- числовые параметры (колонки), которые принимают участие в расчетах (вычисления)
/// "f_приход" <=> a_columnSum -- параметр (колонка) итогового суммирования (как в типовом методе Свернуть())

function fnc_СверткаТЗпоНесколькимПараметрам( a_tValueTable, a_listParameters, a_keyParameter, a_columnsValues, a_columnSum )
	
	тзСвертка_tValueTable=new ValueTable;
	
	///////////////////////////
	//По нескольким параметрам
	///////////////////////////
	
	//свертка по списку a_listParameters
	a_tValueTable_temp = a_tValueTable.Скопировать();
	a_tValueTable_temp.Свернуть( a_listParameters ); 
	
	//свертка по ключевому параметру и колонке суммирования
	a_tValueTable_temp_keyParameter = a_tValueTable_temp.Скопировать(); 
	a_tValueTable_temp_keyParameter.Свернуть( a_keyParameter, a_columnSum ); 

	тзСвертка_tValueTable = a_tValueTable.Скопировать();
	тзСвертка_tValueTable.Очистить();

	Для каждого elm из a_tValueTable_temp_keyParameter цикл
		Отбор = Новый Структура;
		Отбор.Вставить( a_keyParameter, elm[0]); //ключевой параметр всегда на первом месте - поэтому индекс = 0
		НайденныеСтроки = a_tValueTable_temp.НайтиСтроки(Отбор);
		
		if НайденныеСтроки.Количество() > 1 then
			
			arr_columnsValues= РазложитьСтрокуВМассивПодстрок(a_columnsValues);
			
			v_sum_columnSum=0;	
			v_sum_1=0;
			v_sum_2=0; 
			v_sum_3=0;
			v_sum_4=0;
			v_sum_5=0;
			v_sum_6=0;
			v_sum_7=0;
			v_sum_8=0;
			v_sum_9=0;
			v_sum_10=0; 
			
			Для каждого str из НайденныеСтроки цикл
				
				//считаем суммы по данному инструменту

				v_sum_columnSum = v_sum_columnSum + str[a_columnSum];
				str[ a_columnSum ] = v_sum_columnSum;
					
				if arr_columnsValues.Количество()=1 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
				endif;	
				
									
				if arr_columnsValues.Количество()=2 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
				endif;
				
				if arr_columnsValues.Количество()=3 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
				endif;

				if arr_columnsValues.Количество()=4 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
				endif;
				
				if arr_columnsValues.Количество()=5 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					v_sum_5  =  v_sum_5 + str[ trimall(arr_columnsValues[4]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
					str[ trimall(arr_columnsValues[4]) ] = v_sum_5; 
				endif;
				
				if arr_columnsValues.Количество()=6 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					v_sum_5  =  v_sum_5 + str[ trimall(arr_columnsValues[4]) ];
					v_sum_6  =  v_sum_6 + str[ trimall(arr_columnsValues[5]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
					str[ trimall(arr_columnsValues[4]) ] = v_sum_5; 
                    str[ trimall(arr_columnsValues[5]) ] = v_sum_6; 
				endif;
				
				if arr_columnsValues.Количество()=7 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					v_sum_5  =  v_sum_5 + str[ trimall(arr_columnsValues[4]) ];
					v_sum_6  =  v_sum_6 + str[ trimall(arr_columnsValues[5]) ];
					v_sum_7  =  v_sum_7 + str[ trimall(arr_columnsValues[6]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
					str[ trimall(arr_columnsValues[4]) ] = v_sum_5; 
                    str[ trimall(arr_columnsValues[5]) ] = v_sum_6; 
					str[ trimall(arr_columnsValues[6]) ] = v_sum_7; 
				endif;
				
				if arr_columnsValues.Количество()=8 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					v_sum_5  =  v_sum_5 + str[ trimall(arr_columnsValues[4]) ];
					v_sum_6  =  v_sum_6 + str[ trimall(arr_columnsValues[5]) ];
					v_sum_7  =  v_sum_7 + str[ trimall(arr_columnsValues[6]) ];
					v_sum_8  =  v_sum_8 + str[ trimall(arr_columnsValues[7]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
					str[ trimall(arr_columnsValues[4]) ] = v_sum_5; 
                    str[ trimall(arr_columnsValues[5]) ] = v_sum_6; 
					str[ trimall(arr_columnsValues[6]) ] = v_sum_7; 
                    str[ trimall(arr_columnsValues[7]) ] = v_sum_8;
				endif;
				
				if arr_columnsValues.Количество()=9 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					v_sum_5  =  v_sum_5 + str[ trimall(arr_columnsValues[4]) ];
					v_sum_6  =  v_sum_6 + str[ trimall(arr_columnsValues[5]) ];
					v_sum_7  =  v_sum_7 + str[ trimall(arr_columnsValues[6]) ];
					v_sum_8  =  v_sum_8 + str[ trimall(arr_columnsValues[7]) ];
					v_sum_9  =  v_sum_9 + str[ trimall(arr_columnsValues[8]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
					str[ trimall(arr_columnsValues[4]) ] = v_sum_5; 
                    str[ trimall(arr_columnsValues[5]) ] = v_sum_6; 
					str[ trimall(arr_columnsValues[6]) ] = v_sum_7; 
                    str[ trimall(arr_columnsValues[7]) ] = v_sum_8;
                    str[ trimall(arr_columnsValues[8]) ] = v_sum_9;
				endif;
				
				if arr_columnsValues.Количество()=10 then
					v_sum_1  =  v_sum_1 + str[ trimall(arr_columnsValues[0]) ];
					v_sum_2  =  v_sum_2 + str[ trimall(arr_columnsValues[1]) ];
					v_sum_3  =  v_sum_3 + str[ trimall(arr_columnsValues[2]) ];
					v_sum_4  =  v_sum_4 + str[ trimall(arr_columnsValues[3]) ];
					v_sum_5  =  v_sum_5 + str[ trimall(arr_columnsValues[4]) ];
					v_sum_6  =  v_sum_6 + str[ trimall(arr_columnsValues[5]) ];
					v_sum_7  =  v_sum_7 + str[ trimall(arr_columnsValues[6]) ];
					v_sum_8  =  v_sum_8 + str[ trimall(arr_columnsValues[7]) ];
					v_sum_9  =  v_sum_9 + str[ trimall(arr_columnsValues[8]) ];
					v_sum_10 =  v_sum_10 + str[ trimall(arr_columnsValues[9]) ];
					str[ trimall(arr_columnsValues[0]) ] = v_sum_1; 
					str[ trimall(arr_columnsValues[1]) ] = v_sum_2; 
					str[ trimall(arr_columnsValues[2]) ] = v_sum_3; 
					str[ trimall(arr_columnsValues[3]) ] = v_sum_4; 
					str[ trimall(arr_columnsValues[4]) ] = v_sum_5; 
                    str[ trimall(arr_columnsValues[5]) ] = v_sum_6; 
					str[ trimall(arr_columnsValues[6]) ] = v_sum_7; 
                    str[ trimall(arr_columnsValues[7]) ] = v_sum_8;
                    str[ trimall(arr_columnsValues[8]) ] = v_sum_9;
                    str[ trimall(arr_columnsValues[9]) ] = v_sum_10;
				endif;
								
			КонецЦикла;                            
			
            ff=1;
			
		endif;
		
		НоваяСтрока = тзСвертка_tValueTable.Добавить();
		
		if НайденныеСтроки.Количество() = 1 then
			ЗаполнитьЗначенияСвойств( НоваяСтрока, НайденныеСтроки[0]);
		else
			ЗаполнитьЗначенияСвойств( НоваяСтрока, НайденныеСтроки[НайденныеСтроки.Количество() - 1] );
		endif;	

		ff=1;
	КонецЦикла;
   
    return тзСвертка_tValueTable;
	
endFunction
