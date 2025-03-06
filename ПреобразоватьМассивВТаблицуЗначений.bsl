//Вариант 1
function ПреобразоватьМассивВТаблицуЗначений( arrData ) export

	тзResult = Новый ТаблицаЗначений; 
	
	if ЗначениеЗаполнено(arrData) then

		for each elm in arrData do
			for each str in elm.Владелец().Колонки do
				тзResult.Колонки.Добавить(str.Имя);
			enddo;  
			if arrData.Количество() > 1 then
				break;
			endif;
		enddo; 
			
		ff=1;
		
		for each elm in arrData do
			newRow = тзResult.Добавить();
			ЗаполнитьЗначенияСвойств( newRow, elm );
		enddo; 
		
	endif; 

	return тзResult;

endFunction

//Вариант 2 - массив с вложенной структурой
function ПреобразоватьМассивВТаблицуЗначений( arrData ) export

	тзResult = Новый ТаблицаЗначений;

	Для Каждого elm Из arrData Цикл
		
		// Рисуем колонки для таблицы
		Если тзResult.Колонки.Количество() = 0 Тогда
			Для Каждого ЗначениеСтруктуры Из elm Цикл
				тзResult.Колонки.Добавить(ЗначениеСтруктуры.Ключ);
			КонецЦикла;
		КонецЕсли;

		// Добавляем данные в таблицу
		НоваяСтрока = тзResult.Добавить();
		Для Каждого ЗначениеСтруктуры Из elm Цикл
			НоваяСтрока[ЗначениеСтруктуры.Ключ] = ЗначениеСтруктуры.Значение;
		КонецЦикла;
	КонецЦикла;

	return тзResult;

endFunction
