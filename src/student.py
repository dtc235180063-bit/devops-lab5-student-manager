"""
Student Manager — DevOps Lab 5
Module: Student Model
"""

class Student:
    """Lớp đại diện cho một sinh viên."""

    def __init__(self, student_id: str, name: str, age: int, grade: str):
        self.student_id = student_id
        self.name = name
        self.age = age
        self.grade = grade

    def __str__(self) -> str:
        return f"Student(id={self.student_id}, name='{self.name}', age={self.age}, grade='{self.grade}')"

    def to_dict(self) -> dict:
        """Chuyển đối tượng Student thành dictionary."""
        return {
            "student_id": self.student_id,
            "name": self.name,
            "age": self.age,
            "grade": self.grade,
        }


# --- Test nhanh ---
if __name__ == "__main__":
    s1 = Student("SV001", "Nguyen Van A", 20, "K20")
    print(s1)
    print(s1.to_dict())
